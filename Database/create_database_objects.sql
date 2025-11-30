-- Script para crear la tabla "Usuarios" y los procedimientos almacenados necesarios
-- Ejecútelo en su base de datos (por ejemplo con SQL Server Management Studio)

SET NOCOUNT ON;
GO

-- Crear tabla Usuarios si no existe
IF OBJECT_ID('dbo.Usuarios', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Usuarios
    (
        UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        CorreoElectronico NVARCHAR(100) NULL,
        Telefono NVARCHAR(50) NULL,
        Password NVARCHAR(200) NOT NULL
    );
END
GO

-- sp_CrearUsuario
IF OBJECT_ID('dbo.sp_CrearUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CrearUsuario;
GO

CREATE PROCEDURE dbo.sp_CrearUsuario
    @Nombre NVARCHAR(100),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(50),
    @Password NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Usuarios (Nombre, CorreoElectronico, Telefono, Password)
    VALUES (@Nombre, @CorreoElectronico, @Telefono, @Password);

    SELECT CAST(SCOPE_IDENTITY() AS INT) AS UsuarioID;
END
GO

-- sp_ConsultarUsuarios
IF OBJECT_ID('dbo.sp_ConsultarUsuarios', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarUsuarios;
GO

CREATE PROCEDURE dbo.sp_ConsultarUsuarios
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UsuarioID, Nombre, CorreoElectronico, Telefono, Password
    FROM dbo.Usuarios;
END
GO

-- sp_ConsultarUsuarioPorID
IF OBJECT_ID('dbo.sp_ConsultarUsuarioPorID', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarUsuarioPorID;
GO

CREATE PROCEDURE dbo.sp_ConsultarUsuarioPorID
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UsuarioID, Nombre, CorreoElectronico, Telefono, Password
    FROM dbo.Usuarios
    WHERE UsuarioID = @UsuarioID;
END
GO

-- sp_ModificarUsuario
IF OBJECT_ID('dbo.sp_ModificarUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarUsuario;
GO

CREATE PROCEDURE dbo.sp_ModificarUsuario
    @UsuarioID INT,
    @Nombre NVARCHAR(100),
    @CorreoElectronico NVARCHAR(100),
    @Telefono NVARCHAR(50),
    @Password NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Usuarios
    SET Nombre = @Nombre,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        Password = @Password
    WHERE UsuarioID = @UsuarioID;

    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_BorrarUsuario
IF OBJECT_ID('dbo.sp_BorrarUsuario', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BorrarUsuario;
GO

CREATE PROCEDURE dbo.sp_BorrarUsuario
    @UsuarioID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Usuarios WHERE UsuarioID = @UsuarioID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_ValidarLogin
IF OBJECT_ID('dbo.sp_ValidarLogin', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ValidarLogin;
GO

CREATE PROCEDURE dbo.sp_ValidarLogin
    @Nombre NVARCHAR(100),
    @Password NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 UsuarioID, Nombre, CorreoElectronico, Telefono, Password
    FROM dbo.Usuarios
    WHERE Nombre = @Nombre AND Password = @Password;
END
GO
