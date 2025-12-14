<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication3.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <i class="fas fa-recycle"></i>
                <h2>Sistema de Reciclaje</h2>
                <p>Inicia sesión para continuar</p>
            </div>

            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label for="txtEmail"><i class="fas fa-envelope"></i> Correo Electrónico</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="correo@ejemplo.com" required="required"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                    ErrorMessage="El email es requerido" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label for="txtPassword"><i class="fas fa-lock"></i> Contraseña</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Contraseña" required="required"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" 
                    ErrorMessage="La contraseña es requerida" CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
            </div>

            <div class="form-actions">
                <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />
            </div>

            <div class="login-footer">
                <asp:HyperLink ID="lnkRegistro" runat="server" NavigateUrl="~/Registro.aspx" CssClass="link-primary">
                    <i class="fas fa-user-plus"></i> ¿No tienes cuenta? Regístrate aquí
                </asp:HyperLink>
            </div>

            <div class="info-box">
                <h4><i class="fas fa-leaf"></i> ¿Por qué reciclar?</h4>
                <ul>
                    <li>Reduce la contaminación ambiental</li>
                    <li>Conserva recursos naturales</li>
                    <li>Gana puntos y recompensas</li>
                    <li>Contribuye a un planeta más limpio</li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>
