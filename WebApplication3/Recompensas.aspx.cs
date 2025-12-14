using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;
using WebApplication3.Data;
using WebApplication3.Data.Repositories;
using WebApplication3.Models;

namespace WebApplication3
{
    public partial class Recompensas : System.Web.UI.Page
    {
        private RecompensaRepository _recompensaRepo;
        private CanjeRecompensaRepository _canjeRepo;
        private UsuarioRepository _usuarioRepo;
        private DatabaseHelper _db;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _recompensaRepo = new RecompensaRepository();
            _canjeRepo = new CanjeRecompensaRepository();
            _usuarioRepo = new UsuarioRepository();
            _db = new DatabaseHelper();

            if (!IsPostBack)
            {
                CargarPuntosUsuario();
                CargarRecompensas();
                CargarHistorialCanjes();
            }
        }

        private void CargarPuntosUsuario()
        {
            try
            {
                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                var usuario = _usuarioRepo.ObtenerPorId(usuarioId);
                if (usuario != null)
                {
                    lblPuntosDisponibles.Text = usuario.PuntosAcumulados.ToString("N0");
                    Session["UsuarioPuntos"] = usuario.PuntosAcumulados;
                }
            }
            catch (Exception ex)
            {
                lblPuntosDisponibles.Text = "Error";
            }
        }

        private void CargarRecompensas()
        {
            try
            {
                var recompensas = _recompensaRepo.ObtenerTodas();

                if (recompensas != null && recompensas.Count > 0)
                {
                    rptRecompensas.DataSource = recompensas;
                    rptRecompensas.DataBind();
                    pnlSinRecompensas.Visible = false;
                }
                else
                {
                    pnlSinRecompensas.Visible = true;
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al cargar recompensas: " + ex.Message, "danger");
            }
        }

        private void CargarHistorialCanjes()
        {
            try
            {
                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                var canjes = _canjeRepo.ObtenerPorUsuario(usuarioId);

                // Obtener información completa de las recompensas
                var canjesConInfo = canjes.Select(c => new
                {
                    c.FechaCanje,
                    RecompensaNombre = _recompensaRepo.ObtenerPorId(c.RecompensaId)?.Nombre ?? "Recompensa no encontrada",
                    c.PuntosUtilizados,
                    c.EstadoCanje
                }).ToList();

                gvCanjes.DataSource = canjesConInfo;
                gvCanjes.DataBind();
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        protected void rptRecompensas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Canjear")
            {
                try
                {
                    int recompensaId = Convert.ToInt32(e.CommandArgument);
                    int usuarioId = Convert.ToInt32(Session["UsuarioId"]);

                    // Obtener recompensa para mostrar información
                    var recompensa = _recompensaRepo.ObtenerPorId(recompensaId);
                    if (recompensa == null)
                    {
                        MostrarMensaje("❌ Recompensa no encontrada", "danger");
                        return;
                    }

                    // Obtener usuario para verificación previa
                    var usuario = _usuarioRepo.ObtenerPorId(usuarioId);
                    if (usuario == null)
                    {
                        MostrarMensaje("❌ Error: Usuario no encontrado", "danger");
                        return;
                    }

                    // Verificación previa de puntos (la verificación real se hace en el SP)
                    if (usuario.PuntosAcumulados < recompensa.PuntosRequeridos)
                    {
                        MostrarMensaje($"⚠️ No tienes suficientes puntos. Necesitas {recompensa.PuntosRequeridos:N0} puntos pero tienes {usuario.PuntosAcumulados:N0}.", "warning");
                        return;
                    }

                    // Llamar al Stored Procedure que maneja TODO en una transacción
                    var resultado = CanjearRecompensaConSP(usuarioId, recompensaId);

                    if (resultado.Exito)
                    {
                        // Actualizar sesión con los nuevos puntos
                        var usuarioActualizado = _usuarioRepo.ObtenerPorId(usuarioId);
                        if (usuarioActualizado != null)
                        {
                            Session["UsuarioPuntos"] = usuarioActualizado.PuntosAcumulados;
                        }

                        MostrarMensaje($" {resultado.Mensaje}", "success");

                        // Recargar todos los datos
                        CargarPuntosUsuario();
                        CargarRecompensas();
                        CargarHistorialCanjes();
                    }
                    else
                    {
                        MostrarMensaje($"❌ {resultado.Mensaje}", "danger");

                        // Recargar para refrescar datos
                        CargarPuntosUsuario();
                        CargarRecompensas();
                    }
                }
                catch (System.Data.SqlClient.SqlException sqlEx)
                {
                    // Error específico de SQL
                    MostrarMensaje($"❌ Error de base de datos: {sqlEx.Message} (Código: {sqlEx.Number})", "danger");
                }
                catch (Exception ex)
                {
                    // Error general
                    MostrarMensaje($"❌ Error inesperado: {ex.Message}", "danger");
                }
            }
        }

        /// <summary>
        /// Ejecuta el stored procedure sp_CanjearRecompensa que maneja todo en una transacción
        /// </summary>
        private ResultadoCanje CanjearRecompensaConSP(int usuarioId, int recompensaId)
        {
            var resultado = new ResultadoCanje();

            try
            {
                using (var connection = _db.GetConnection())
                {
                    connection.Open();

                    using (var command = new SqlCommand("sp_CanjearRecompensa", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        // Parámetros de entrada
                        command.Parameters.AddWithValue("@UsuarioId", usuarioId);
                        command.Parameters.AddWithValue("@RecompensaId", recompensaId);

                        // Ejecutar y leer resultado
                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                resultado.Exito = Convert.ToInt32(reader["Resultado"]) == 1;
                                resultado.Mensaje = reader["Mensaje"].ToString();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                resultado.Exito = false;
                resultado.Mensaje = $"Error al ejecutar el canje: {ex.Message}";
            }

            return resultado;
        }

        protected string ObtenerClaseEstado(string estado)
        {
            switch (estado)
            {
                case "Entregado":
                    return "success";
                case "Pendiente":
                    return "warning";
                case "Cancelado":
                    return "danger";
                default:
                    return "secondary";
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert alert-" + tipo;
            lblMensaje.Text = mensaje;
        }

        /// <summary>
        /// Clase auxiliar para el resultado del canje
        /// </summary>
        private class ResultadoCanje
        {
            public bool Exito { get; set; }
            public string Mensaje { get; set; }
        }
    }
}
