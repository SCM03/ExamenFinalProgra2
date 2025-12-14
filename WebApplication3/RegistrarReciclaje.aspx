<%@ Page Title="Registrar Reciclaje" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegistrarReciclaje.aspx.cs" Inherits="WebApplication3.RegistrarReciclaje" Culture="auto" UICulture="auto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="reciclar-container">
        <div class="page-header">
            <h1><i class="fas fa-plus-circle"></i> Registrar Reciclaje</h1>
            <p>Registra el material que has reciclado y gana puntos</p>
        </div>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert">
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>
        </asp:Panel>

        <div class="registro-form-card">
            <div class="form-section">
                <h3><i class="fas fa-leaf"></i> Información del Material</h3>
                
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="ddlTipoMaterial"><i class="fas fa-recycle"></i> Tipo de Material *</label>
                        <asp:DropDownList ID="ddlTipoMaterial" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlTipoMaterial_SelectedIndexChanged">
                            <asp:ListItem Value="">-- Seleccione un tipo --</asp:ListItem>
                            <asp:ListItem Value="Orgánico">Orgánico</asp:ListItem>
                            <asp:ListItem Value="Inorgánico">Inorgánico</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTipo" runat="server" ControlToValidate="ddlTipoMaterial" 
                            ErrorMessage="Seleccione un tipo de material" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group col-md-6">
                        <label for="ddlMaterial"><i class="fas fa-boxes"></i> Material Específico *</label>
                        <asp:DropDownList ID="ddlMaterial" runat="server" CssClass="form-control" DataTextField="Nombre" DataValueField="Id" OnSelectedIndexChanged="ddlMaterial_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Value="">-- Seleccione un material --</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvMaterial" runat="server" ControlToValidate="ddlMaterial" 
                            ErrorMessage="Seleccione un material" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <asp:Panel ID="pnlInfoMaterial" runat="server" Visible="false" CssClass="info-material">
                    <div class="material-info">
                        <h4><asp:Label ID="lblMaterialNombre" runat="server"></asp:Label></h4>
                        <p><asp:Label ID="lblMaterialDescripcion" runat="server"></asp:Label></p>
                        <div class="material-stats">
                            <span class="badge badge-success">
                                <i class="fas fa-star"></i> <asp:Label ID="lblPuntosPorKilo" runat="server"></asp:Label> puntos/kg
                            </span>
                            <span class="badge badge-info">
                                <asp:Label ID="lblCategoria" runat="server"></asp:Label>
                            </span>
                        </div>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtCantidad"><i class="fas fa-weight"></i> Cantidad en Kilogramos *</label>
                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" placeholder="Ej: 2.5" OnTextChanged="txtCantidad_TextChanged" AutoPostBack="true"></asp:TextBox>
                    <small class="form-text text-muted">Ingrese la cantidad en kilogramos (use punto o coma como decimal)</small>
                    <asp:RequiredFieldValidator ID="rfvCantidad" runat="server" ControlToValidate="txtCantidad" 
                        ErrorMessage="Ingrese la cantidad" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvCantidad" runat="server" ControlToValidate="txtCantidad" 
                        Operator="DataTypeCheck" Type="Double"
                        ErrorMessage="Ingrese un número válido" CssClass="text-danger" Display="Dynamic"></asp:CompareValidator>
                    <asp:CustomValidator ID="customValidatorCantidad" runat="server" 
                        ControlToValidate="txtCantidad"
                        OnServerValidate="ValidarCantidad"
                        ErrorMessage="La cantidad debe ser mayor a 0 y menor a 10000 kg" 
                        CssClass="text-danger" Display="Dynamic"></asp:CustomValidator>
                </div>

                <asp:Panel ID="pnlCalculoPuntos" runat="server" Visible="false" CssClass="calculo-puntos">
                    <div class="puntos-preview">
                        <i class="fas fa-calculator"></i>
                        <div>
                            <strong>Puntos que ganarás:</strong>
                            <h2><asp:Label ID="lblPuntosCalculados" runat="server" CssClass="text-success"></asp:Label> puntos</h2>
                        </div>
                    </div>
                </asp:Panel>

                <div class="form-group">
                    <label for="txtObservaciones"><i class="fas fa-comment"></i> Observaciones (Opcional)</label>
                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Agrega notas adicionales sobre este reciclaje"></asp:TextBox>
                </div>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar Reciclaje" CssClass="btn btn-primary btn-lg" OnClick="btnRegistrar_Click" />
                <asp:HyperLink ID="lnkCancelar" runat="server" NavigateUrl="~/Dashboard.aspx" CssClass="btn btn-secondary">Cancelar</asp:HyperLink>
            </div>
        </div>

        <!-- Guía rápida de reciclaje -->
        <div class="guia-reciclaje">
            <h3><i class="fas fa-info-circle"></i> Guía Rápida de Reciclaje</h3>
            <div class="guia-grid">
                <div class="guia-item organico">
                    <i class="fas fa-leaf"></i>
                    <h4>Materiales Orgánicos</h4>
                    <ul>
                        <li>Restos de frutas y verduras</li>
                        <li>Cáscaras de huevo</li>
                        <li>Residuos de jardín</li>
                        <li>Papel compostable</li>
                    </ul>
                </div>
                <div class="guia-item inorganico">
                    <i class="fas fa-recycle"></i>
                    <h4>Materiales Inorgánicos</h4>
                    <ul>
                        <li>Plásticos (PET, HDPE)</li>
                        <li>Vidrio limpio</li>
                        <li>Metales (latas, aluminio)</li>
                        <li>Papel y cartón</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
