-- Procedimientos almacenados para Reparacion

-- Tabla base (si no existe)
IF OBJECT_ID('dbo.Reparacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Reparacion
    (
        ReparacionID INT IDENTITY(1,1) PRIMARY KEY,
        EquipoID INT NOT NULL,
        TecnicoID INT NOT NULL,
        EstadoReparacion NVARCHAR(100) NOT NULL,
        FechaIngreso DATETIME NOT NULL
    );
END
GO

-- sp_CrearReparacion
IF OBJECT_ID('dbo.sp_CrearReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CrearReparacion;
GO
CREATE PROCEDURE dbo.sp_CrearReparacion
    @EquipoID INT,
    @TecnicoID INT,
    @EstadoReparacion NVARCHAR(100),
    @FechaIngreso DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Reparacion (EquipoID, TecnicoID, EstadoReparacion, FechaIngreso)
    VALUES (@EquipoID, @TecnicoID, @EstadoReparacion, @FechaIngreso);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS ReparacionID;
END
GO

-- sp_ConsultarReparaciones
IF OBJECT_ID('dbo.sp_ConsultarReparaciones', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarReparaciones;
GO
CREATE PROCEDURE dbo.sp_ConsultarReparaciones
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Reparacion;
END
GO

-- sp_ConsultarReparacionPorID
IF OBJECT_ID('dbo.sp_ConsultarReparacionPorID', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarReparacionPorID;
GO
CREATE PROCEDURE dbo.sp_ConsultarReparacionPorID
    @ReparacionID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Reparacion WHERE ReparacionID = @ReparacionID;
END
GO

-- sp_ModificarReparacion
IF OBJECT_ID('dbo.sp_ModificarReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarReparacion;
GO
CREATE PROCEDURE dbo.sp_ModificarReparacion
    @ReparacionID INT,
    @EquipoID INT,
    @TecnicoID INT,
    @EstadoReparacion NVARCHAR(100),
    @FechaIngreso DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Reparacion
    SET EquipoID = @EquipoID,
        TecnicoID = @TecnicoID,
        EstadoReparacion = @EstadoReparacion,
        FechaIngreso = @FechaIngreso
    WHERE ReparacionID = @ReparacionID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_BorrarReparacion
IF OBJECT_ID('dbo.sp_BorrarReparacion', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BorrarReparacion;
GO
CREATE PROCEDURE dbo.sp_BorrarReparacion
    @ReparacionID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Reparacion WHERE ReparacionID = @ReparacionID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
