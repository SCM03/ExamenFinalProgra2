using System;
using WebApplication3.Data.Repositories;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
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

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsValid)
                    return;

                var usuario = _usuarioRepo.ValidarLogin(txtEmail.Text.Trim(), txtPassword.Text);

                if (usuario != null)
                {
                    // Guardar en sesión
                    Session["UsuarioId"] = usuario.Id;
                    Session["UsuarioNombre"] = usuario.NombreCompleto;
                    Session["UsuarioEmail"] = usuario.Email;
                    Session["UsuarioPuntos"] = usuario.PuntosAcumulados;

                    // Redirigir al dashboard
                    Response.Redirect("Dashboard.aspx");
                }
                else
                {
                    MostrarMensaje("Email o contraseña incorrectos", "danger");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al iniciar sesión: " + ex.Message, "danger");
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
