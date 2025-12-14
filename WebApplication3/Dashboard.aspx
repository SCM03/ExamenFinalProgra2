<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebApplication3.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1><i class="fas fa-recycle"></i> Dashboard de Reciclaje</h1>
            <p>Bienvenido, <strong><asp:Label ID="lblUsuarioNombre" runat="server"></asp:Label></strong></p>
        </div>

        <!-- Tarjetas de estadísticas principales -->
        <div class="stats-grid">
            <div class="stat-card puntos-card">
                <div class="stat-icon"><i class="fas fa-star"></i></div>
                <div class="stat-content">
                    <h3><asp:Label ID="lblPuntosAcumulados" runat="server">0</asp:Label></h3>
                    <p>Puntos Acumulados</p>
                    <span class="stat-badge"><asp:Label ID="lblNivel" runat="server"></asp:Label></span>
                </div>
            </div>

            <div class="stat-card kilos-card">
                <div class="stat-icon"><i class="fas fa-weight"></i></div>
                <div class="stat-content">
                    <h3><asp:Label ID="lblTotalKilos" runat="server">0</asp:Label> kg</h3>
                    <p>Total Reciclado</p>
                </div>
            </div>

            <div class="stat-card transacciones-card">
                <div class="stat-icon"><i class="fas fa-list"></i></div>
                <div class="stat-content">
                    <h3><asp:Label ID="lblTotalTransacciones" runat="server">0</asp:Label></h3>
                    <p>Reciclajes Realizados</p>
                </div>
            </div>

            <div class="stat-card impacto-card">
                <div class="stat-icon"><i class="fas fa-leaf"></i></div>
                <div class="stat-content">
                    <h3><asp:Label ID="lblImpactoAmbiental" runat="server">0</asp:Label> CO?</h3>
                    <p>Impacto Ambiental</p>
                </div>
            </div>
        </div>

        <!-- Acciones rápidas -->
        <div class="quick-actions">
            <h2><i class="fas fa-bolt"></i> Acciones Rápidas</h2>
            <div class="actions-grid">
                <asp:HyperLink ID="lnkRegistrarReciclaje" runat="server" NavigateUrl="~/RegistrarReciclaje.aspx" CssClass="action-card reciclar-action">
                    <i class="fas fa-plus-circle"></i>
                    <h3>Registrar Reciclaje</h3>
                    <p>Registra tu material reciclado y gana puntos</p>
                </asp:HyperLink>

                <asp:HyperLink ID="lnkRecompensas" runat="server" NavigateUrl="~/Recompensas.aspx" CssClass="action-card recompensas-action">
                    <i class="fas fa-gift"></i>
                    <h3>Ver Recompensas</h3>
                    <p>Canjea tus puntos por premios</p>
                </asp:HyperLink>

                <asp:HyperLink ID="lnkEstadisticas" runat="server" NavigateUrl="~/Estadisticas.aspx" CssClass="action-card stats-action">
                    <i class="fas fa-chart-bar"></i>
                    <h3>Estadísticas</h3>
                    <p>Visualiza tu progreso y el impacto</p>
                </asp:HyperLink>
            </div>
        </div>

        <!-- Últimas transacciones -->
        <div class="recent-transactions">
            <h2><i class="fas fa-history"></i> Últimos Reciclajes</h2>
            <asp:GridView ID="gvTransacciones" runat="server" CssClass="table table-hover" AutoGenerateColumns="false" EmptyDataText="No hay reciclajes registrados aún">
                <Columns>
                    <asp:BoundField DataField="FechaReciclaje" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:BoundField DataField="MaterialNombre" HeaderText="Material" />
                    <asp:BoundField DataField="CantidadKilos" HeaderText="Cantidad (kg)" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="PuntosGanados" HeaderText="Puntos Ganados" DataFormatString="{0:N0}" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- Ranking de usuarios -->
        <div class="ranking-section">
            <h2><i class="fas fa-trophy"></i> Top 5 Recicladores</h2>
            <asp:GridView ID="gvRanking" runat="server" CssClass="table table-striped" AutoGenerateColumns="false">
                <Columns>
                    <asp:TemplateField HeaderText="Posición">
                        <ItemTemplate>
                            <%# Container.DataItemIndex + 1 %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="NombreCompleto" HeaderText="Usuario" />
                    <asp:BoundField DataField="PuntosAcumulados" HeaderText="Puntos" DataFormatString="{0:N0}" />
                    <asp:BoundField DataField="TotalKilosReciclados" HeaderText="Kilos Reciclados" DataFormatString="{0:N2}" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
