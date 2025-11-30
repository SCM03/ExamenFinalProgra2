-- Procedimientos almacenados para Tecnico

-- Tabla base (si no existe)
IF OBJECT_ID('dbo.Tecnico', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tecnico
    (
        TecnicoID INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Especialidad NVARCHAR(100) NULL
    );
END
GO

-- sp_CrearTecnico
IF OBJECT_ID('dbo.sp_CrearTecnico', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CrearTecnico;
GO
CREATE PROCEDURE dbo.sp_CrearTecnico
    @Nombre NVARCHAR(100),
    @Especialidad NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Tecnico (Nombre, Especialidad)
    VALUES (@Nombre, @Especialidad);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS TecnicoID;
END
GO

-- sp_ConsultarTecnicos
IF OBJECT_ID('dbo.sp_ConsultarTecnicos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarTecnicos;
GO
CREATE PROCEDURE dbo.sp_ConsultarTecnicos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Tecnico;
END
GO

-- sp_ConsultarTecnicoPorID
IF OBJECT_ID('dbo.sp_ConsultarTecnicoPorID', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarTecnicoPorID;
GO
CREATE PROCEDURE dbo.sp_ConsultarTecnicoPorID
    @TecnicoID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Tecnico WHERE TecnicoID = @TecnicoID;
END
GO

-- sp_ModificarTecnico
IF OBJECT_ID('dbo.sp_ModificarTecnico', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarTecnico;
GO
CREATE PROCEDURE dbo.sp_ModificarTecnico
    @TecnicoID INT,
    @Nombre NVARCHAR(100),
    @Especialidad NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Tecnico
    SET Nombre = @Nombre,
        Especialidad = @Especialidad
    WHERE TecnicoID = @TecnicoID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_BorrarTecnico
IF OBJECT_ID('dbo.sp_BorrarTecnico', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BorrarTecnico;
GO
CREATE PROCEDURE dbo.sp_BorrarTecnico
    @TecnicoID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Tecnico WHERE TecnicoID = @TecnicoID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
