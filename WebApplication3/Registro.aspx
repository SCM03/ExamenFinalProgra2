<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="WebApplication3.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="registro-container">
        <div class="registro-card">
            <h2><i class="fas fa-user-plus"></i> Registro de Usuario</h2>
            <p class="subtitle">Únete a nuestra comunidad de reciclaje</p>

            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label for="txtNombre"><i class="fas fa-user"></i> Nombre Completo *</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Juan Pérez" required="required"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" 
                    ErrorMessage="El nombre es requerido" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtEmail"><i class="fas fa-envelope"></i> Correo Electrónico *</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="correo@ejemplo.com" required="required"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                    ErrorMessage="El email es requerido" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
                    ErrorMessage="Email inválido" CssClass="text-danger" Display="Dynamic"></asp:RegularExpressionValidator>
            </div>

            <div class="form-group">
                <label for="txtPassword"><i class="fas fa-lock"></i> Contraseña *</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Mínimo 6 caracteres" required="required"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                    ErrorMessage="La contraseña es requerida" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtTelefono"><i class="fas fa-phone"></i> Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="+56 9 1234 5678"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtDireccion"><i class="fas fa-map-marker-alt"></i> Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" placeholder="Dirección completa"></asp:TextBox>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrarse" CssClass="btn btn-primary" OnClick="btnRegistrar_Click" />
                <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" CssClass="btn btn-link">¿Ya tienes cuenta? Inicia sesión</asp:HyperLink>
            </div>
        </div>
    </div>
</asp:Content>
