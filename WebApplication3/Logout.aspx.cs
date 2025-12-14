using System;

namespace WebApplication3
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Limpiar todas las variables de sesión
            Session.Clear();
            Session.Abandon();
            
            // Redirigir al login
            Response.Redirect("Login.aspx");
        }
    }
}
