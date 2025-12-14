using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using WebApplication3.Data.Repositories;

namespace WebApplication3
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private UsuarioRepository _usuarioRepo;
        private TransaccionReciclajeRepository _transaccionRepo;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _usuarioRepo = new UsuarioRepository();
            _transaccionRepo = new TransaccionReciclajeRepository();

            if (!IsPostBack)
            {
                CargarDatosUsuario();
                CargarUltimasTransacciones();
                CargarRanking();
            }
        }

        private void CargarDatosUsuario()
        {
            try
            {
                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                var usuario = _usuarioRepo.ObtenerPorId(usuarioId);

                if (usuario != null)
                {
                    lblUsuarioNombre.Text = usuario.NombreCompleto;
                    lblPuntosAcumulados.Text = usuario.PuntosAcumulados.ToString("N0");
                    lblTotalKilos.Text = usuario.TotalKilosReciclados.ToString("N2");
                    lblTotalTransacciones.Text = usuario.TotalReciclajesRealizados.ToString();
                    lblNivel.Text = usuario.ObtenerNivel();

                    // Calcular impacto ambiental aproximado (1 kg reciclado = ~2 kg CO2 evitado)
                    decimal impactoCO2 = usuario.TotalKilosReciclados * 2;
                    lblImpactoAmbiental.Text = impactoCO2.ToString("N0") + " kg";

                    // Actualizar sesión
                    Session["UsuarioPuntos"] = usuario.PuntosAcumulados;
                }
            }
            catch (Exception ex)
            {
                // Log error
                lblUsuarioNombre.Text = "Error al cargar datos";
            }
        }

        private void CargarUltimasTransacciones()
        {
            try
            {
                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                var transacciones = _transaccionRepo.ObtenerPorUsuario(usuarioId);
                
                // Obtener las últimas 5 transacciones con información del material
                var materialRepo = new MaterialRepository();
                var transaccionesConMaterial = transacciones.Take(5).Select(t => new
                {
                    t.FechaReciclaje,
                    MaterialNombre = materialRepo.ObtenerPorId(t.MaterialId)?.Nombre ?? "Material no encontrado",
                    t.CantidadKilos,
                    t.PuntosGanados
                }).ToList();

                gvTransacciones.DataSource = transaccionesConMaterial;
                gvTransacciones.DataBind();
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        private void CargarRanking()
        {
            try
            {
                var usuarios = _usuarioRepo.ObtenerTodos();
                var top5 = usuarios.OrderByDescending(u => u.PuntosAcumulados).Take(5).ToList();

                gvRanking.DataSource = top5;
                gvRanking.DataBind();
            }
            catch (Exception ex)
            {
                // Log error
            }
        }
    }
}
