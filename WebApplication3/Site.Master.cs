using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar si el usuario está logueado
            if (Session["UsuarioId"] != null)
            {
                // Usuario logueado - mostrar menú de usuario
                phMenuLogueado.Visible = true;
                phMenuPublico.Visible = false;
                
                // Mostrar nombre y puntos del usuario
                lblUsuarioNombre.Text = Session["UsuarioNombre"]?.ToString() ?? "Usuario";
                lblUsuarioPuntos.Text = Session["UsuarioPuntos"]?.ToString() ?? "0";
            }
            else
            {
                // Usuario no logueado - mostrar menú público
                phMenuLogueado.Visible = false;
                phMenuPublico.Visible = true;
            }
        }
    }
}