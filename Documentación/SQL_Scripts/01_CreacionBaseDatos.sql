-- ====================================================================
-- SISTEMA DE GESTIÓN DE RECICLAJE
-- Scripts SQL Completos para SQL Server
-- ====================================================================

-- ====================================================================
-- PARTE 1: CREACIÓN DE BASE DE DATOS
-- ====================================================================

USE master;
GO

-- Eliminar base de datos si existe (solo para desarrollo)
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ReciclajeDB')
BEGIN
    ALTER DATABASE ReciclajeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ReciclajeDB;
END
GO

-- Crear base de datos
CREATE DATABASE ReciclajeDB;
GO

USE ReciclajeDB;
GO

-- ====================================================================
-- PARTE 2: CREACIÓN DE TABLAS
-- ====================================================================

-- Tabla: Usuarios
CREATE TABLE Usuarios (
    Id INT PRIMARY KEY IDENTITY(1,1),
    NombreCompleto NVARCHAR(200) NOT NULL,
    Email NVARCHAR(200) NOT NULL UNIQUE,
    Password NVARCHAR(200) NOT NULL,
    Telefono NVARCHAR(50),
    Direccion NVARCHAR(500),
    PuntosAcumulados DECIMAL(18,2) DEFAULT 0,
    TotalReciclajesRealizados INT DEFAULT 0,
    TotalKilosReciclados DECIMAL(18,2) DEFAULT 0,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- Índices para Usuarios
CREATE INDEX IX_Usuarios_Email ON Usuarios(Email);
CREATE INDEX IX_Usuarios_Activo ON Usuarios(Activo);
GO

-- Tabla: Materiales (soporta tanto orgánicos como inorgánicos)
CREATE TABLE Materiales (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(200) NOT NULL,
    TipoMaterial NVARCHAR(50) NOT NULL CHECK (TipoMaterial IN ('Orgánico', 'Inorgánico')),
    PuntosPorKilo DECIMAL(18,2) NOT NULL,
    Descripcion NVARCHAR(1000),
    
    -- Campos para materiales orgánicos
    EsCompostable BIT NULL,
    
    -- Campos para materiales inorgánicos
    SubCategoria NVARCHAR(100) NULL, -- Plástico, Vidrio, Metal, Papel
    RequiereLimpiezaPrevia BIT NULL,
    
    -- Campo común para tiempo de descomposición
    TiempoDescomposicion INT NULL, -- En días para orgánicos, años para inorgánicos
    
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- Índices para Materiales
CREATE INDEX IX_Materiales_TipoMaterial ON Materiales(TipoMaterial);
CREATE INDEX IX_Materiales_Activo ON Materiales(Activo);
GO

-- Tabla: TransaccionesReciclaje
CREATE TABLE TransaccionesReciclaje (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    MaterialId INT NOT NULL,
    CantidadKilos DECIMAL(18,2) NOT NULL,
    PuntosGanados DECIMAL(18,2) NOT NULL,
    Observaciones NVARCHAR(1000),
    FechaReciclaje DATETIME NOT NULL DEFAULT GETDATE(),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_Transacciones_Usuario FOREIGN KEY (UsuarioId) 
        REFERENCES Usuarios(Id),
    CONSTRAINT FK_Transacciones_Material FOREIGN KEY (MaterialId) 
        REFERENCES Materiales(Id)
);
GO

-- Índices para TransaccionesReciclaje
CREATE INDEX IX_Transacciones_UsuarioId ON TransaccionesReciclaje(UsuarioId);
CREATE INDEX IX_Transacciones_MaterialId ON TransaccionesReciclaje(MaterialId);
CREATE INDEX IX_Transacciones_FechaReciclaje ON TransaccionesReciclaje(FechaReciclaje);
GO

-- Tabla: Recompensas
CREATE TABLE Recompensas (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(200) NOT NULL,
    Descripcion NVARCHAR(1000),
    PuntosRequeridos DECIMAL(18,2) NOT NULL,
    StockDisponible INT NOT NULL DEFAULT 0,
    ImagenUrl NVARCHAR(500),
    Categoria NVARCHAR(100),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- Índices para Recompensas
CREATE INDEX IX_Recompensas_PuntosRequeridos ON Recompensas(PuntosRequeridos);
CREATE INDEX IX_Recompensas_Activo ON Recompensas(Activo);
GO

-- Tabla: CanjesRecompensas
CREATE TABLE CanjesRecompensas (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    RecompensaId INT NOT NULL,
    PuntosUtilizados DECIMAL(18,2) NOT NULL,
    FechaCanje DATETIME NOT NULL DEFAULT GETDATE(),
    EstadoCanje NVARCHAR(50) NOT NULL DEFAULT 'Pendiente' 
        CHECK (EstadoCanje IN ('Pendiente', 'Entregado', 'Cancelado')),
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    Activo BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_Canjes_Usuario FOREIGN KEY (UsuarioId) 
        REFERENCES Usuarios(Id),
    CONSTRAINT FK_Canjes_Recompensa FOREIGN KEY (RecompensaId) 
        REFERENCES Recompensas(Id)
);
GO

-- Índices para CanjesRecompensas
CREATE INDEX IX_Canjes_UsuarioId ON CanjesRecompensas(UsuarioId);
CREATE INDEX IX_Canjes_RecompensaId ON CanjesRecompensas(RecompensaId);
CREATE INDEX IX_Canjes_FechaCanje ON CanjesRecompensas(FechaCanje);
GO

-- ====================================================================
-- PARTE 3: PROCEDIMIENTOS ALMACENADOS
-- ====================================================================

-- Procedimiento: Registrar Reciclaje Completo (Transacción)
CREATE PROCEDURE sp_RegistrarReciclaje
    @UsuarioId INT,
    @MaterialId INT,
    @CantidadKilos DECIMAL(18,2),
    @PuntosGanados DECIMAL(18,2),
    @Observaciones NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Insertar transacción
        INSERT INTO TransaccionesReciclaje (UsuarioId, MaterialId, CantidadKilos, PuntosGanados, Observaciones)
        VALUES (@UsuarioId, @MaterialId, @CantidadKilos, @PuntosGanados, @Observaciones);
        
        -- Actualizar usuario
        UPDATE Usuarios
        SET PuntosAcumulados = PuntosAcumulados + @PuntosGanados,
            TotalReciclajesRealizados = TotalReciclajesRealizados + 1,
            TotalKilosReciclados = TotalKilosReciclados + @CantidadKilos,
            FechaModificacion = GETDATE()
        WHERE Id = @UsuarioId;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Reciclaje registrado exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- Procedimiento: Canjear Recompensa (Transacción)
CREATE PROCEDURE sp_CanjearRecompensa
    @UsuarioId INT,
    @RecompensaId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @PuntosRequeridos DECIMAL(18,2);
        DECLARE @PuntosUsuario DECIMAL(18,2);
        DECLARE @StockDisponible INT;
        
        -- Obtener puntos requeridos y stock
        SELECT @PuntosRequeridos = PuntosRequeridos, @StockDisponible = StockDisponible
        FROM Recompensas
        WHERE Id = @RecompensaId AND Activo = 1;
        
        -- Obtener puntos del usuario
        SELECT @PuntosUsuario = PuntosAcumulados
        FROM Usuarios
        WHERE Id = @UsuarioId AND Activo = 1;
        
        -- Validaciones
        IF @PuntosRequeridos IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'Recompensa no encontrada' AS Mensaje;
            RETURN;
        END
        
        IF @StockDisponible <= 0
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'Recompensa agotada' AS Mensaje;
            RETURN;
        END
        
        IF @PuntosUsuario < @PuntosRequeridos
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS Resultado, 'Puntos insuficientes' AS Mensaje;
            RETURN;
        END
        
        -- Insertar canje
        INSERT INTO CanjesRecompensas (UsuarioId, RecompensaId, PuntosUtilizados)
        VALUES (@UsuarioId, @RecompensaId, @PuntosRequeridos);
        
        -- Descontar puntos del usuario
        UPDATE Usuarios
        SET PuntosAcumulados = PuntosAcumulados - @PuntosRequeridos,
            FechaModificacion = GETDATE()
        WHERE Id = @UsuarioId;
        
        -- Reducir stock
        UPDATE Recompensas
        SET StockDisponible = StockDisponible - 1,
            FechaModificacion = GETDATE()
        WHERE Id = @RecompensaId;
        
        COMMIT TRANSACTION;
        SELECT 1 AS Resultado, 'Recompensa canjeada exitosamente' AS Mensaje;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 0 AS Resultado, ERROR_MESSAGE() AS Mensaje;
    END CATCH
END
GO

-- Procedimiento: Obtener Estadísticas Generales
CREATE PROCEDURE sp_ObtenerEstadisticasGenerales
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(DISTINCT UsuarioId) as TotalUsuarios,
        COUNT(*) as TotalTransacciones,
        ISNULL(SUM(CantidadKilos), 0) as TotalKilosReciclados,
        ISNULL(SUM(PuntosGanados), 0) as TotalPuntosGenerados
    FROM TransaccionesReciclaje 
    WHERE Activo = 1;
END
GO

-- Procedimiento: Obtener Ranking de Usuarios
CREATE PROCEDURE sp_ObtenerRankingUsuarios
    @Top INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@Top)
        Id,
        NombreCompleto,
        Email,
        PuntosAcumulados,
        TotalKilosReciclados,
        TotalReciclajesRealizados,
        CASE 
            WHEN PuntosAcumulados >= 10000 THEN 'Diamante'
            WHEN PuntosAcumulados >= 5000 THEN 'Oro'
            WHEN PuntosAcumulados >= 2000 THEN 'Plata'
            WHEN PuntosAcumulados >= 500 THEN 'Bronce'
            ELSE 'Principiante'
        END AS Nivel
    FROM Usuarios
    WHERE Activo = 1
    ORDER BY PuntosAcumulados DESC;
END
GO

-- ====================================================================
-- PARTE 4: VISTAS
-- ====================================================================

-- Vista: Transacciones con detalles
CREATE VIEW vw_TransaccionesDetalle
AS
SELECT 
    t.Id,
    t.UsuarioId,
    u.NombreCompleto AS UsuarioNombre,
    u.Email AS UsuarioEmail,
    t.MaterialId,
    m.Nombre AS MaterialNombre,
    m.TipoMaterial,
    t.CantidadKilos,
    t.PuntosGanados,
    t.Observaciones,
    t.FechaReciclaje
FROM TransaccionesReciclaje t
INNER JOIN Usuarios u ON t.UsuarioId = u.Id
INNER JOIN Materiales m ON t.MaterialId = m.Id
WHERE t.Activo = 1;
GO

-- Vista: Canjes con detalles
CREATE VIEW vw_CanjesDetalle
AS
SELECT 
    c.Id,
    c.UsuarioId,
    u.NombreCompleto AS UsuarioNombre,
    c.RecompensaId,
    r.Nombre AS RecompensaNombre,
    c.PuntosUtilizados,
    c.FechaCanje,
    c.EstadoCanje
FROM CanjesRecompensas c
INNER JOIN Usuarios u ON c.UsuarioId = u.Id
INNER JOIN Recompensas r ON c.RecompensaId = r.Id
WHERE c.Activo = 1;
GO

-- ====================================================================
-- PARTE 5: TRIGGERS
-- ====================================================================

-- Trigger: Validar puntos antes de canje
CREATE TRIGGER trg_ValidarPuntosAntesCanjeREMOVED
ON CanjesRecompensas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @UsuarioId INT, @RecompensaId INT, @PuntosRequeridos DECIMAL(18,2), @PuntosUsuario DECIMAL(18,2);
    
    SELECT @UsuarioId = UsuarioId, @RecompensaId = RecompensaId FROM inserted;
    
    SELECT @PuntosRequeridos = PuntosRequeridos FROM Recompensas WHERE Id = @RecompensaId;
    SELECT @PuntosUsuario = PuntosAcumulados FROM Usuarios WHERE Id = @UsuarioId;
    
    IF @PuntosUsuario >= @PuntosRequeridos
    BEGIN
        INSERT INTO CanjesRecompensas (UsuarioId, RecompensaId, PuntosUtilizados, FechaCanje, EstadoCanje, FechaCreacion, Activo)
        SELECT UsuarioId, RecompensaId, @PuntosRequeridos, FechaCanje, EstadoCanje, FechaCreacion, Activo FROM inserted;
    END
    ELSE
    BEGIN
        RAISERROR('Puntos insuficientes para canjear esta recompensa', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- ====================================================================
-- PARTE 6: FUNCIONES
-- ====================================================================

-- Función: Calcular nivel de usuario
CREATE FUNCTION fn_CalcularNivelUsuario(@PuntosAcumulados DECIMAL(18,2))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Nivel NVARCHAR(50);
    
    IF @PuntosAcumulados >= 10000
        SET @Nivel = 'Diamante';
    ELSE IF @PuntosAcumulados >= 5000
        SET @Nivel = 'Oro';
    ELSE IF @PuntosAcumulados >= 2000
        SET @Nivel = 'Plata';
    ELSE IF @PuntosAcumulados >= 500
        SET @Nivel = 'Bronce';
    ELSE
        SET @Nivel = 'Principiante';
    
    RETURN @Nivel;
END
GO

-- Función: Calcular CO2 evitado
CREATE FUNCTION fn_CalcularCO2Evitado(@KilosReciclados DECIMAL(18,2))
RETURNS DECIMAL(18,2)
AS
BEGIN
    -- Aproximación: 1 kg reciclado = 2 kg CO2 evitado
    RETURN @KilosReciclados * 2;
END
GO

PRINT 'Tablas, procedimientos, vistas, triggers y funciones creados exitosamente';
GO
