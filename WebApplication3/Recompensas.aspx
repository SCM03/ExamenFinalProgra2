<%@ Page Title="Recompensas" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Recompensas.aspx.cs" Inherits="WebApplication3.Recompensas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="recompensas-container">
        <div class="page-header">
            <h1><i class="fas fa-gift"></i> Recompensas Disponibles</h1>
            <div class="puntos-disponibles">
                <i class="fas fa-star"></i>
                <span>Tus puntos: <strong><asp:Label ID="lblPuntosDisponibles" runat="server">0</asp:Label></strong></span>
            </div>
        </div>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert">
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>
        </asp:Panel>

        <div class="recompensas-grid">
            <asp:Repeater ID="rptRecompensas" runat="server" OnItemCommand="rptRecompensas_ItemCommand">
                <ItemTemplate>
                    <div class="recompensa-card">
                        <div class="recompensa-imagen">
                            <i class="fas fa-gift fa-3x"></i>
                        </div>
                        <div class="recompensa-info">
                            <h3><%# Eval("Nombre") %></h3>
                            <p class="descripcion"><%# Eval("Descripcion") %></p>
                            <div class="recompensa-detalles">
                                <span class="puntos-requeridos">
                                    <i class="fas fa-star"></i> <%# String.Format("{0:N0}", Eval("PuntosRequeridos")) %> puntos
                                </span>
                                <span class="stock <%# Convert.ToInt32(Eval("StockDisponible")) > 0 ? "disponible" : "agotado" %>">
                                    <i class="fas fa-box"></i> 
                                    <%# Convert.ToInt32(Eval("StockDisponible")) > 0 ? 
                                        "Stock: " + Eval("StockDisponible") : 
                                        "Agotado" %>
                                </span>
                            </div>
                        </div>
                        <div class="recompensa-accion">
                            <asp:Button ID="btnCanjear" runat="server" 
                                Text="Canjear" 
                                CssClass='<%# Convert.ToInt32(Eval("StockDisponible")) > 0 ? "btn btn-success" : "btn btn-secondary disabled" %>'
                                CommandName="Canjear" 
                                CommandArgument='<%# Eval("Id") %>'
                                Enabled='<%# Convert.ToInt32(Eval("StockDisponible")) > 0 %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlSinRecompensas" runat="server" Visible="false" CssClass="alert alert-info">
            <i class="fas fa-info-circle"></i> No hay recompensas disponibles en este momento.
        </asp:Panel>

        <!-- Historial de canjes -->
        <div class="historial-section">
            <h2><i class="fas fa-history"></i> Mis Canjes Recientes</h2>
            <asp:GridView ID="gvCanjes" runat="server" CssClass="table table-striped" AutoGenerateColumns="false" EmptyDataText="No has canjeado recompensas aún">
                <Columns>
                    <asp:BoundField DataField="FechaCanje" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:BoundField DataField="RecompensaNombre" HeaderText="Recompensa" />
                    <asp:BoundField DataField="PuntosUtilizados" HeaderText="Puntos Utilizados" DataFormatString="{0:N0}" />
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <span class='badge badge-<%# ObtenerClaseEstado(Eval("EstadoCanje").ToString()) %>'>
                                <%# Eval("EstadoCanje") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- Información sobre cómo ganar más puntos -->
        <div class="info-puntos">
            <h3><i class="fas fa-lightbulb"></i> ¿Cómo ganar más puntos?</h3>
            <div class="consejos-grid">
                <div class="consejo-item">
                    <i class="fas fa-recycle"></i>
                    <h4>Recicla Regularmente</h4>
                    <p>Registra tus reciclajes frecuentemente</p>
                </div>
                <div class="consejo-item">
                    <i class="fas fa-weight-hanging"></i>
                    <h4>Mayor Cantidad</h4>
                    <p>Más kilos = más puntos acumulados</p>
                </div>
                <div class="consejo-item">
                    <i class="fas fa-gem"></i>
                    <h4>Materiales Premium</h4>
                    <p>Metales y vidrios dan más puntos</p>
                </div>
                <div class="consejo-item">
                    <i class="fas fa-leaf"></i>
                    <h4>Compostaje</h4>
                    <p>Orgánicos compostables tienen bonificación</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
