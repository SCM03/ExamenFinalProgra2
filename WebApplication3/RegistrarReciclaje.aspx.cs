using System;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using WebApplication3.Data.Repositories;
using WebApplication3.Models;
using WebApplication3.Models.Base;

namespace WebApplication3
{
    public partial class RegistrarReciclaje : System.Web.UI.Page
    {
        private MaterialRepository _materialRepo;
        private TransaccionReciclajeRepository _transaccionRepo;
        private UsuarioRepository _usuarioRepo;
        private MaterialBase _materialSeleccionado;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _materialRepo = new MaterialRepository();
            _transaccionRepo = new TransaccionReciclajeRepository();
            _usuarioRepo = new UsuarioRepository();

            if (!IsPostBack)
            {
                // Cargar tipos de material ya está en el ASPX
            }
        }

        protected void ddlTipoMaterial_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlTipoMaterial.SelectedValue))
            {
                CargarMaterialesPorTipo(ddlTipoMaterial.SelectedValue);
            }
            else
            {
                ddlMaterial.Items.Clear();
                ddlMaterial.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione un material --", ""));
                pnlInfoMaterial.Visible = false;
                pnlCalculoPuntos.Visible = false;
            }
        }

        protected void ddlMaterial_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(ddlMaterial.SelectedValue))
            {
                MostrarInformacionMaterial(Convert.ToInt32(ddlMaterial.SelectedValue));
                CalcularPuntos();
            }
            else
            {
                pnlInfoMaterial.Visible = false;
                pnlCalculoPuntos.Visible = false;
            }
        }

        protected void txtCantidad_TextChanged(object sender, EventArgs e)
        {
            CalcularPuntos();
        }

        // Validación personalizada para la cantidad
        protected void ValidarCantidad(object source, ServerValidateEventArgs args)
        {
            try
            {
                // Intentar parsear con diferentes culturas
                decimal cantidad;
                string valor = args.Value.Replace(",", "."); // Normalizar

                if (decimal.TryParse(valor, NumberStyles.Any, CultureInfo.InvariantCulture, out cantidad))
                {
                    args.IsValid = (cantidad > 0 && cantidad <= 10000);
                }
                else
                {
                    args.IsValid = false;
                }
            }
            catch
            {
                args.IsValid = false;
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                    return;

                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                int materialId = Convert.ToInt32(ddlMaterial.SelectedValue);

                // Parsear cantidad con manejo de cultura
                decimal cantidad = ParsearDecimal(txtCantidad.Text);

                // Obtener material para calcular puntos (usando polimorfismo)
                var material = _materialRepo.ObtenerPorId(materialId);
                decimal puntos = material.CalcularPuntos(cantidad); // Polimorfismo en acción

                // Crear transacción
                var transaccion = new TransaccionReciclaje
                {
                    UsuarioId = usuarioId,
                    MaterialId = materialId,
                    CantidadKilos = cantidad,
                    PuntosGanados = puntos,
                    Observaciones = txtObservaciones.Text.Trim(),
                    FechaReciclaje = DateTime.Now
                };

                int transaccionId = _transaccionRepo.Insertar(transaccion);

                if (transaccionId > 0)
                {
                    // Actualizar puntos del usuario
                    var usuario = _usuarioRepo.ObtenerPorId(usuarioId);
                    usuario.AgregarPuntos(puntos, cantidad);
                    _usuarioRepo.Actualizar(usuario);

                    // Actualizar sesión
                    Session["UsuarioPuntos"] = usuario.PuntosAcumulados;

                    MostrarMensaje($"¡Reciclaje registrado exitosamente! Has ganado {puntos:N0} puntos.", "success");
                    LimpiarFormulario();
                }
                else
                {
                    MostrarMensaje("Error al registrar el reciclaje. Intente nuevamente.", "danger");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "danger");
            }
        }

        private decimal ParsearDecimal(string valor)
        {
            // Intentar parsear con diferentes culturas
            decimal resultado;

            // Normalizar: reemplazar comas por puntos
            string valorNormalizado = valor.Replace(",", ".");

            if (decimal.TryParse(valorNormalizado, NumberStyles.Any, CultureInfo.InvariantCulture, out resultado))
            {
                return resultado;
            }

            // Si falla, intentar con la cultura actual
            if (decimal.TryParse(valor, NumberStyles.Any, CultureInfo.CurrentCulture, out resultado))
            {
                return resultado;
            }

            throw new FormatException("No se pudo convertir el valor a decimal");
        }

        private void CargarMaterialesPorTipo(string tipo)
        {
            var materiales = _materialRepo.ObtenerPorTipo(tipo);
            ddlMaterial.DataSource = materiales;
            ddlMaterial.DataTextField = "Nombre";
            ddlMaterial.DataValueField = "Id";
            ddlMaterial.DataBind();
            ddlMaterial.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione un material --", ""));
        }

        private void MostrarInformacionMaterial(int materialId)
        {
            _materialSeleccionado = _materialRepo.ObtenerPorId(materialId);
            if (_materialSeleccionado != null)
            {
                lblMaterialNombre.Text = _materialSeleccionado.Nombre;
                lblMaterialDescripcion.Text = _materialSeleccionado.Descripcion ?? "Material reciclable";
                lblPuntosPorKilo.Text = _materialSeleccionado.PuntosPorKilo.ToString("N0");
                lblCategoria.Text = _materialSeleccionado.ObtenerCategoria(); // Polimorfismo
                pnlInfoMaterial.Visible = true;
            }
        }

        private void CalcularPuntos()
        {
            if (!string.IsNullOrEmpty(ddlMaterial.SelectedValue) && !string.IsNullOrEmpty(txtCantidad.Text))
            {
                try
                {
                    int materialId = Convert.ToInt32(ddlMaterial.SelectedValue);
                    decimal cantidad = ParsearDecimal(txtCantidad.Text);

                    var material = _materialRepo.ObtenerPorId(materialId);
                    decimal puntos = material.CalcularPuntos(cantidad); // Polimorfismo

                    lblPuntosCalculados.Text = puntos.ToString("N0");
                    pnlCalculoPuntos.Visible = true;
                }
                catch
                {
                    pnlCalculoPuntos.Visible = false;
                }
            }
        }

        private void LimpiarFormulario()
        {
            ddlTipoMaterial.SelectedIndex = 0;
            ddlMaterial.Items.Clear();
            ddlMaterial.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Seleccione un material --", ""));
            txtCantidad.Text = string.Empty;
            txtObservaciones.Text = string.Empty;
            pnlInfoMaterial.Visible = false;
            pnlCalculoPuntos.Visible = false;
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert alert-" + tipo;
            lblMensaje.Text = mensaje;
        }
    }
}
