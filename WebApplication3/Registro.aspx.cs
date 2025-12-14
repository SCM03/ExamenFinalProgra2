using System;
using WebApplication3.Data.Repositories;
using WebApplication3.Models;

namespace WebApplication3
{
    public partial class Registro : System.Web.UI.Page
    {
        private UsuarioRepository _usuarioRepo;

        protected void Page_Load(object sender, EventArgs e)
        {
            _usuarioRepo = new UsuarioRepository();

            if (!IsPostBack)
            {
                // Verificar si ya está logueado
                if (Session["UsuarioId"] != null)
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                    return;

                // Verificar si el email ya existe
                var usuarioExistente = _usuarioRepo.ObtenerPorEmail(txtEmail.Text.Trim());
                if (usuarioExistente != null)
                {
                    MostrarMensaje("El correo electrónico ya está registrado", "danger");
                    return;
                }

                // Crear nuevo usuario
                var nuevoUsuario = new Usuario
                {
                    NombreCompleto = txtNombre.Text.Trim(),
                    Email = txtEmail.Text.Trim(),
                    Password = txtPassword.Text, // En producción, usar hash
                    Telefono = txtTelefono.Text.Trim(),
                    Direccion = txtDireccion.Text.Trim()
                };

                int usuarioId = _usuarioRepo.Insertar(nuevoUsuario);

                if (usuarioId > 0)
                {
                    // Login automático
                    Session["UsuarioId"] = usuarioId;
                    Session["UsuarioNombre"] = nuevoUsuario.NombreCompleto;
                    Session["UsuarioEmail"] = nuevoUsuario.Email;

                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    MostrarMensaje("Error al registrar el usuario. Intente nuevamente.", "danger");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "danger");
            }
        }

        private void MostrarMensaje(string mensaje, string tipo)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "alert alert-" + tipo;
            lblMensaje.Text = mensaje;
        }
    }
}
