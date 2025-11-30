-- Procedimientos almacenados para Equipo

-- Tabla base (si no existe)
IF OBJECT_ID('dbo.Equipo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Equipo
    (
        EquipoID INT IDENTITY(1,1) PRIMARY KEY,
        TipoEquipo NVARCHAR(100) NOT NULL,
        Modelo NVARCHAR(100) NOT NULL,
        NumeroSerie NVARCHAR(100) NULL
    );
END
GO

-- sp_CrearEquipo
IF OBJECT_ID('dbo.sp_CrearEquipo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CrearEquipo;
GO
CREATE PROCEDURE dbo.sp_CrearEquipo
    @TipoEquipo NVARCHAR(100),
    @Modelo NVARCHAR(100),
    @NumeroSerie NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Equipo (TipoEquipo, Modelo, NumeroSerie)
    VALUES (@TipoEquipo, @Modelo, @NumeroSerie);
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS EquipoID;
END
GO

-- sp_ConsultarEquipos
IF OBJECT_ID('dbo.sp_ConsultarEquipos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarEquipos;
GO
CREATE PROCEDURE dbo.sp_ConsultarEquipos
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Equipo;
END
GO

-- sp_ConsultarEquipoPorID
IF OBJECT_ID('dbo.sp_ConsultarEquipoPorID', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ConsultarEquipoPorID;
GO
CREATE PROCEDURE dbo.sp_ConsultarEquipoPorID
    @EquipoID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Equipo WHERE EquipoID = @EquipoID;
END
GO

-- sp_ModificarEquipo
IF OBJECT_ID('dbo.sp_ModificarEquipo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ModificarEquipo;
GO
CREATE PROCEDURE dbo.sp_ModificarEquipo
    @EquipoID INT,
    @TipoEquipo NVARCHAR(100),
    @Modelo NVARCHAR(100),
    @NumeroSerie NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Equipo
    SET TipoEquipo = @TipoEquipo,
        Modelo = @Modelo,
        NumeroSerie = @NumeroSerie
    WHERE EquipoID = @EquipoID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO

-- sp_BorrarEquipo
IF OBJECT_ID('dbo.sp_BorrarEquipo', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_BorrarEquipo;
GO
CREATE PROCEDURE dbo.sp_BorrarEquipo
    @EquipoID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Equipo WHERE EquipoID = @EquipoID;
    SELECT @@ROWCOUNT AS RowsAffected;
END
GO
