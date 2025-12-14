<%@ Page Title="Estadísticas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Estadisticas.aspx.cs" Inherits="WebApplication3.Estadisticas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="estadisticas-container">
        <div class="page-header">
            <h1><i class="fas fa-chart-bar"></i> Estadísticas de Reciclaje</h1>
            <p>Visualiza el impacto ambiental de tu comunidad</p>
        </div>

        <!-- Estadísticas Generales -->
        <div class="stats-generales">
            <h2><i class="fas fa-globe"></i> Impacto Global de la Comunidad</h2>
            <div class="stats-grid-large">
                <div class="stat-box total-usuarios">
                    <i class="fas fa-users"></i>
                    <h3><asp:Label ID="lblTotalUsuarios" runat="server">0</asp:Label></h3>
                    <p>Usuarios Activos</p>
                </div>
                <div class="stat-box total-transacciones">
                    <i class="fas fa-exchange-alt"></i>
                    <h3><asp:Label ID="lblTotalTransacciones" runat="server">0</asp:Label></h3>
                    <p>Reciclajes Realizados</p>
                </div>
                <div class="stat-box total-kilos">
                    <i class="fas fa-weight-hanging"></i>
                    <h3><asp:Label ID="lblTotalKilos" runat="server">0</asp:Label> kg</h3>
                    <p>Total Reciclado</p>
                </div>
                <div class="stat-box total-puntos">
                    <i class="fas fa-star"></i>
                    <h3><asp:Label ID="lblTotalPuntos" runat="server">0</asp:Label></h3>
                    <p>Puntos Generados</p>
                </div>
            </div>
        </div>

        <!-- Estadísticas por Material -->
        <div class="stats-material">
            <h2><i class="fas fa-layer-group"></i> Distribución por Material</h2>
            <div class="chart-container">
                <canvas id="chartMateriales"></canvas>
            </div>
            <asp:GridView ID="gvEstadisticasMaterial" runat="server" CssClass="table table-striped" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField DataField="Material" HeaderText="Material" />
                    <asp:BoundField DataField="TipoMaterial" HeaderText="Tipo" />
                    <asp:BoundField DataField="TotalTransacciones" HeaderText="Cantidad de Reciclajes" DataFormatString="{0:N0}" />
                    <asp:BoundField DataField="TotalKilos" HeaderText="Kilos Totales" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="TotalPuntos" HeaderText="Puntos Generados" DataFormatString="{0:N0}" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Mis Estadísticas Personales -->
        <div class="stats-personales">
            <h2><i class="fas fa-user-chart"></i> Mis Estadísticas Personales</h2>
            <div class="personal-grid">
                <div class="personal-card">
                    <i class="fas fa-trophy"></i>
                    <h3>Tu Nivel</h3>
                    <p class="nivel-badge"><asp:Label ID="lblMiNivel" runat="server"></asp:Label></p>
                </div>
                <div class="personal-card">
                    <i class="fas fa-percentage"></i>
                    <h3>Contribución</h3>
                    <p><asp:Label ID="lblPorcentajeContribucion" runat="server">0</asp:Label>%</p>
                    <small>del total de la comunidad</small>
                </div>
                <div class="personal-card">
                    <i class="fas fa-leaf"></i>
                    <h3>CO? Evitado</h3>
                    <p><asp:Label ID="lblCO2Evitado" runat="server">0</asp:Label> kg</p>
                    <small>aproximadamente</small>
                </div>
                <div class="personal-card">
                    <i class="fas fa-calendar-check"></i>
                    <h3>Días Activo</h3>
                    <p><asp:Label ID="lblDiasActivo" runat="server">0</asp:Label> días</p>
                </div>
            </div>
        </div>

        <!-- Comparativa Orgánico vs Inorgánico -->
        <div class="comparativa-section">
            <h2><i class="fas fa-balance-scale"></i> Orgánico vs Inorgánico</h2>
            <div class="comparativa-grid">
                <div class="comparativa-card organico">
                    <i class="fas fa-leaf"></i>
                    <h3>Materiales Orgánicos</h3>
                    <div class="stat-row">
                        <span>Kilos:</span>
                        <strong><asp:Label ID="lblKilosOrganico" runat="server">0</asp:Label> kg</strong>
                    </div>
                    <div class="stat-row">
                        <span>Reciclajes:</span>
                        <strong><asp:Label ID="lblTransaccionesOrganico" runat="server">0</asp:Label></strong>
                    </div>
                </div>
                <div class="comparativa-card inorganico">
                    <i class="fas fa-recycle"></i>
                    <h3>Materiales Inorgánicos</h3>
                    <div class="stat-row">
                        <span>Kilos:</span>
                        <strong><asp:Label ID="lblKilosInorganico" runat="server">0</asp:Label> kg</strong>
                    </div>
                    <div class="stat-row">
                        <span>Reciclajes:</span>
                        <strong><asp:Label ID="lblTransaccionesInorganico" runat="server">0</asp:Label></strong>
                    </div>
                </div>
            </div>
            <div class="chart-container-small">
                <canvas id="chartComparativa"></canvas>
            </div>
        </div>

        <!-- Información Educativa -->
        <div class="info-educativa">
            <h2><i class="fas fa-graduation-cap"></i> Impacto Ambiental del Reciclaje</h2>
            <div class="info-grid">
                <div class="info-card">
                    <i class="fas fa-tree"></i>
                    <h4>Ahorro de Árboles</h4>
                    <p>Cada tonelada de papel reciclado salva aproximadamente 17 árboles</p>
                </div>
                <div class="info-card">
                    <i class="fas fa-tint"></i>
                    <h4>Ahorro de Agua</h4>
                    <p>El reciclaje de plástico ahorra hasta 70% de agua en producción</p>
                </div>
                <div class="info-card">
                    <i class="fas fa-bolt"></i>
                    <h4>Ahorro de Energía</h4>
                    <p>Reciclar aluminio ahorra 95% de energía vs. producción nueva</p>
                </div>
                <div class="info-card">
                    <i class="fas fa-smog"></i>
                    <h4>Reducción de CO?</h4>
                    <p>El reciclaje reduce emisiones de gases de efecto invernadero</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts para gráficos Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
    <script type="text/javascript">
        // Estos datos serán inyectados desde el code-behind
        var materialesData = <%= GetMaterialesChartData() %>;
        var comparativaData = <%= GetComparativaChartData() %>;

        // Gráfico de materiales
        if (document.getElementById('chartMateriales')) {
            var ctx1 = document.getElementById('chartMateriales').getContext('2d');
            new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: materialesData.labels,
                    datasets: [{
                        label: 'Kilos Reciclados',
                        data: materialesData.data,
                        backgroundColor: [
                            'rgba(75, 192, 192, 0.6)',
                            'rgba(54, 162, 235, 0.6)',
                            'rgba(255, 206, 86, 0.6)',
                            'rgba(153, 102, 255, 0.6)',
                            'rgba(255, 99, 132, 0.6)'
                        ],
                        borderColor: [
                            'rgba(75, 192, 192, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)',
                            'rgba(153, 102, 255, 1)',
                            'rgba(255, 99, 132, 1)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Kilogramos'
                            }
                        }
                    }
                }
            });
        }

        // Gráfico comparativa
        if (document.getElementById('chartComparativa')) {
            var ctx2 = document.getElementById('chartComparativa').getContext('2d');
            new Chart(ctx2, {
                type: 'doughnut',
                data: {
                    labels: ['Orgánico', 'Inorgánico'],
                    datasets: [{
                        data: [comparativaData.organico, comparativaData.inorganico],
                        backgroundColor: [
                            'rgba(76, 175, 80, 0.8)',
                            'rgba(33, 150, 243, 0.8)'
                        ],
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
    </script>
</asp:Content>
