-- Procedimientos almacenados para DetalleReparacion

-- Tabla base (si no existe)
IF OBJECT_ID('dbo.DetalleReparacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.DetalleReparacion
    (
        DetalleID INT IDENTITY(1,1) PRIMARY KEY,
        ReparacionID INT NOT NULL,
        Descripcion NVARCHAR(500) NOT NULL,
        FechaInicio DATETIME NOT NULL,
        FechaFin DATETIME NULL
    );
END
GO

-- sp_CrearDetalleReparacion
IF OBJECT_ID('dbo.sp_CrearDetalleReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CrearDetalleReparacion;
GO
CREATE PROCEDURE dbo.sp_CrearDetalleReparacion
    @ReparacionID INT,
    @Descripcion NVARCHAR(500),
    @FechaInicio DATETIME,
    @FechaFin DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.DetalleReparacion (ReparacionID, Descripcion, FechaInicio, FechaFin)
    VALUES (@ReparacionID, @Descripcion, @FechaInicio, @FechaFin);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS DetalleID;
END
GO

-- sp_ConsultarDetallesReparacion
IF OBJECT_ID('dbo.sp_ConsultarDetallesReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarDetallesReparacion;
GO
CREATE PROCEDURE dbo.sp_ConsultarDetallesReparacion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT d.*, r.EstadoReparacion, e.TipoEquipo, e.Modelo
    FROM dbo.DetalleReparacion d
    LEFT JOIN dbo.Reparacion r ON d.ReparacionID = r.ReparacionID
    LEFT JOIN dbo.Equipo e ON r.EquipoID = e.EquipoID;
END
GO

-- sp_ConsultarDetallesPorReparacion
IF OBJECT_ID('dbo.sp_ConsultarDetallesPorReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarDetallesPorReparacion;
GO
CREATE PROCEDURE dbo.sp_ConsultarDetallesPorReparacion
    @ReparacionID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DetalleReparacion WHERE ReparacionID = @ReparacionID;
END
GO

-- sp_ConsultarDetallePorID
IF OBJECT_ID('dbo.sp_ConsultarDetallePorID', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarDetallePorID;
GO
CREATE PROCEDURE dbo.sp_ConsultarDetallePorID
    @DetalleID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DetalleReparacion WHERE DetalleID = @DetalleID;
END
GO

-- sp_ModificarDetalleReparacion
IF OBJECT_ID('dbo.sp_ModificarDetalleReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarDetalleReparacion;
GO
CREATE PROCEDURE dbo.sp_ModificarDetalleReparacion
    @DetalleID INT,
    @ReparacionID INT,
    @Descripcion NVARCHAR(500),
    @FechaInicio DATETIME,
    @FechaFin DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DetalleReparacion
    SET ReparacionID = @ReparacionID,
        Descripcion = @Descripcion,
        FechaInicio = @FechaInicio,
        FechaFin = @FechaFin
    WHERE DetalleID = @DetalleID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_BorrarDetalleReparacion
IF OBJECT_ID('dbo.sp_BorrarDetalleReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BorrarDetalleReparacion;
GO
CREATE PROCEDURE dbo.sp_BorrarDetalleReparacion
    @DetalleID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DetalleReparacion WHERE DetalleID = @DetalleID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
