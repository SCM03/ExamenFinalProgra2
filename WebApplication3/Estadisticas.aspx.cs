using System;
using System.Data;
using System.Linq;
using System.Web.Script.Serialization;
using WebApplication3.Data.Repositories;

namespace WebApplication3
{
    public partial class Estadisticas : System.Web.UI.Page
    {
        private TransaccionReciclajeRepository _transaccionRepo;
        private UsuarioRepository _usuarioRepo;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar autenticación
            if (Session["UsuarioId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            _transaccionRepo = new TransaccionReciclajeRepository();
            _usuarioRepo = new UsuarioRepository();

            if (!IsPostBack)
            {
                CargarEstadisticasGenerales();
                CargarEstadisticasPorMaterial();
                CargarEstadisticasPersonales();
                CargarComparativaOrganicoInorganico();
            }
        }

        private void CargarEstadisticasGenerales()
        {
            try
            {
                var dt = _transaccionRepo.ObtenerEstadisticasGenerales();
                if (dt.Rows.Count > 0)
                {
                    var row = dt.Rows[0];
                    lblTotalUsuarios.Text = row["TotalUsuarios"].ToString();
                    lblTotalTransacciones.Text = Convert.ToInt32(row["TotalTransacciones"]).ToString("N0");
                    lblTotalKilos.Text = Convert.ToDecimal(row["TotalKilosReciclados"]).ToString("N2");
                    lblTotalPuntos.Text = Convert.ToDecimal(row["TotalPuntosGenerados"]).ToString("N0");
                }
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        private void CargarEstadisticasPorMaterial()
        {
            try
            {
                var dt = _transaccionRepo.ObtenerEstadisticasPorMaterial();
                gvEstadisticasMaterial.DataSource = dt;
                gvEstadisticasMaterial.DataBind();
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        private void CargarEstadisticasPersonales()
        {
            try
            {
                int usuarioId = Convert.ToInt32(Session["UsuarioId"]);
                var usuario = _usuarioRepo.ObtenerPorId(usuarioId);

                if (usuario != null)
                {
                    lblMiNivel.Text = usuario.ObtenerNivel();
                    
                    // Calcular CO2 evitado (aproximado: 2 kg CO2 por kg reciclado)
                    decimal co2Evitado = usuario.TotalKilosReciclados * 2;
                    lblCO2Evitado.Text = co2Evitado.ToString("N2");

                    // Calcular días activo
                    TimeSpan diasActivo = DateTime.Now - usuario.FechaCreacion;
                    lblDiasActivo.Text = diasActivo.Days.ToString();

                    // Calcular porcentaje de contribución
                    var statsGenerales = _transaccionRepo.ObtenerEstadisticasGenerales();
                    if (statsGenerales.Rows.Count > 0)
                    {
                        decimal totalKilosComunidad = Convert.ToDecimal(statsGenerales.Rows[0]["TotalKilosReciclados"]);
                        if (totalKilosComunidad > 0)
                        {
                            decimal porcentaje = (usuario.TotalKilosReciclados / totalKilosComunidad) * 100;
                            lblPorcentajeContribucion.Text = porcentaje.ToString("N2");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        private void CargarComparativaOrganicoInorganico()
        {
            try
            {
                var dtMateriales = _transaccionRepo.ObtenerEstadisticasPorMaterial();
                
                decimal kilosOrganico = 0;
                decimal kilosInorganico = 0;
                int transaccionesOrganico = 0;
                int transaccionesInorganico = 0;

                foreach (DataRow row in dtMateriales.Rows)
                {
                    string tipo = row["TipoMaterial"].ToString();
                    decimal kilos = Convert.ToDecimal(row["TotalKilos"]);
                    int transacciones = Convert.ToInt32(row["TotalTransacciones"]);

                    if (tipo == "Orgánico")
                    {
                        kilosOrganico += kilos;
                        transaccionesOrganico += transacciones;
                    }
                    else
                    {
                        kilosInorganico += kilos;
                        transaccionesInorganico += transacciones;
                    }
                }

                lblKilosOrganico.Text = kilosOrganico.ToString("N2");
                lblKilosInorganico.Text = kilosInorganico.ToString("N2");
                lblTransaccionesOrganico.Text = transaccionesOrganico.ToString("N0");
                lblTransaccionesInorganico.Text = transaccionesInorganico.ToString("N0");
            }
            catch (Exception ex)
            {
                // Log error
            }
        }

        // Métodos para generar datos JSON para los gráficos
        protected string GetMaterialesChartData()
        {
            try
            {
                var dt = _transaccionRepo.ObtenerEstadisticasPorMaterial();
                var labels = dt.AsEnumerable().Select(r => r["Material"].ToString()).ToList();
                var data = dt.AsEnumerable().Select(r => Convert.ToDecimal(r["TotalKilos"])).ToList();

                var chartData = new
                {
                    labels = labels,
                    data = data
                };

                var serializer = new JavaScriptSerializer();
                return serializer.Serialize(chartData);
            }
            catch
            {
                return "{ labels: [], data: [] }";
            }
        }

        protected string GetComparativaChartData()
        {
            try
            {
                var dtMateriales = _transaccionRepo.ObtenerEstadisticasPorMaterial();
                
                decimal kilosOrganico = 0;
                decimal kilosInorganico = 0;

                foreach (DataRow row in dtMateriales.Rows)
                {
                    string tipo = row["TipoMaterial"].ToString();
                    decimal kilos = Convert.ToDecimal(row["TotalKilos"]);

                    if (tipo == "Orgánico")
                        kilosOrganico += kilos;
                    else
                        kilosInorganico += kilos;
                }

                var chartData = new
                {
                    organico = kilosOrganico,
                    inorganico = kilosInorganico
                };

                var serializer = new JavaScriptSerializer();
                return serializer.Serialize(chartData);
            }
            catch
            {
                return "{ organico: 0, inorganico: 0 }";
            }
        }
    }
}
