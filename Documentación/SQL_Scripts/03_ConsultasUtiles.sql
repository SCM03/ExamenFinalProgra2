-- ====================================================================
-- CONSULTAS ÚTILES PARA SISTEMA DE GESTIÓN DE RECICLAJE
-- ====================================================================

USE ReciclajeDB;
GO

-- ====================================================================
-- CONSULTAS DE VERIFICACIÓN
-- ====================================================================

-- Verificar todos los usuarios
SELECT * FROM Usuarios ORDER BY PuntosAcumulados DESC;

-- Verificar todos los materiales
SELECT * FROM Materiales ORDER BY TipoMaterial, Nombre;

-- Verificar todas las recompensas
SELECT * FROM Recompensas ORDER BY PuntosRequeridos;

-- Verificar todas las transacciones
SELECT * FROM TransaccionesReciclaje ORDER BY FechaReciclaje DESC;

-- Verificar todos los canjes
SELECT * FROM CanjesRecompensas ORDER BY FechaCanje DESC;

GO

-- ====================================================================
-- CONSULTAS DE ESTADÍSTICAS
-- ====================================================================

-- Estadísticas generales del sistema
SELECT 
    COUNT(DISTINCT UsuarioId) as TotalUsuariosActivos,
    COUNT(*) as TotalTransacciones,
    SUM(CantidadKilos) as TotalKilosReciclados,
    SUM(PuntosGanados) as TotalPuntosGenerados,
    AVG(CantidadKilos) as PromedioKilosPorTransaccion
FROM TransaccionesReciclaje 
WHERE Activo = 1;

-- Estadísticas por tipo de material
SELECT 
    M.TipoMaterial,
    COUNT(*) as TotalTransacciones,
    SUM(T.CantidadKilos) as TotalKilos,
    SUM(T.PuntosGanados) as TotalPuntos,
    AVG(T.CantidadKilos) as PromedioKilos
FROM TransaccionesReciclaje T
INNER JOIN Materiales M ON T.MaterialId = M.Id
WHERE T.Activo = 1
GROUP BY M.TipoMaterial
ORDER BY TotalKilos DESC;

-- Estadísticas por material específico
SELECT 
    M.Nombre as Material,
    M.TipoMaterial,
    M.SubCategoria,
    COUNT(*) as TotalTransacciones,
    SUM(T.CantidadKilos) as TotalKilos,
    SUM(T.PuntosGanados) as TotalPuntos
FROM TransaccionesReciclaje T
INNER JOIN Materiales M ON T.MaterialId = M.Id
WHERE T.Activo = 1
GROUP BY M.Nombre, M.TipoMaterial, M.SubCategoria
ORDER BY TotalKilos DESC;

-- Ranking de usuarios por puntos
SELECT 
    ROW_NUMBER() OVER (ORDER BY PuntosAcumulados DESC) as Posicion,
    NombreCompleto,
    Email,
    PuntosAcumulados,
    TotalKilosReciclados,
    TotalReciclajesRealizados,
    dbo.fn_CalcularNivelUsuario(PuntosAcumulados) as Nivel,
    DATEDIFF(day, FechaCreacion, GETDATE()) as DiasActivo
FROM Usuarios
WHERE Activo = 1
ORDER BY PuntosAcumulados DESC;

-- Top 10 materiales más reciclados
SELECT TOP 10
    M.Nombre,
    M.TipoMaterial,
    COUNT(*) as VecesReciclado,
    SUM(T.CantidadKilos) as TotalKilos,
    SUM(T.PuntosGanados) as PuntosGenerados
FROM TransaccionesReciclaje T
INNER JOIN Materiales M ON T.MaterialId = M.Id
WHERE T.Activo = 1
GROUP BY M.Nombre, M.TipoMaterial
ORDER BY TotalKilos DESC;

-- Recompensas más canjeadas
SELECT 
    R.Nombre,
    R.Categoria,
    R.PuntosRequeridos,
    COUNT(C.Id) as VecesCanjeada,
    SUM(C.PuntosUtilizados) as TotalPuntosUtilizados
FROM Recompensas R
LEFT JOIN CanjesRecompensas C ON R.Id = C.RecompensaId AND C.Activo = 1
WHERE R.Activo = 1
GROUP BY R.Nombre, R.Categoria, R.PuntosRequeridos
ORDER BY VecesCanjeada DESC;

-- Impacto ambiental total (CO2 evitado)
SELECT 
    SUM(TotalKilosReciclados) as TotalKilos,
    dbo.fn_CalcularCO2Evitado(SUM(TotalKilosReciclados)) as CO2EvitadoKg,
    dbo.fn_CalcularCO2Evitado(SUM(TotalKilosReciclados)) / 1000 as CO2EvitadoToneladas
FROM Usuarios
WHERE Activo = 1;

GO

-- ====================================================================
-- CONSULTAS POR USUARIO
-- ====================================================================

-- Historial completo de un usuario (usar @UsuarioId)
DECLARE @UsuarioId INT = 1;

-- Información del usuario
SELECT 
    U.NombreCompleto,
    U.Email,
    U.PuntosAcumulados,
    U.TotalKilosReciclados,
    U.TotalReciclajesRealizados,
    dbo.fn_CalcularNivelUsuario(U.PuntosAcumulados) as Nivel,
    dbo.fn_CalcularCO2Evitado(U.TotalKilosReciclados) as CO2EvitadoKg,
    DATEDIFF(day, U.FechaCreacion, GETDATE()) as DiasActivo
FROM Usuarios U
WHERE U.Id = @UsuarioId;

-- Transacciones del usuario
SELECT 
    T.FechaReciclaje,
    M.Nombre as Material,
    M.TipoMaterial,
    T.CantidadKilos,
    T.PuntosGanados,
    T.Observaciones
FROM TransaccionesReciclaje T
INNER JOIN Materiales M ON T.MaterialId = M.Id
WHERE T.UsuarioId = @UsuarioId AND T.Activo = 1
ORDER BY T.FechaReciclaje DESC;

-- Canjes del usuario
SELECT 
    C.FechaCanje,
    R.Nombre as Recompensa,
    C.PuntosUtilizados,
    C.EstadoCanje
FROM CanjesRecompensas C
INNER JOIN Recompensas R ON C.RecompensaId = R.Id
WHERE C.UsuarioId = @UsuarioId AND C.Activo = 1
ORDER BY C.FechaCanje DESC;

-- Estadísticas personales por tipo de material
SELECT 
    M.TipoMaterial,
    COUNT(*) as TotalTransacciones,
    SUM(T.CantidadKilos) as TotalKilos,
    SUM(T.PuntosGanados) as TotalPuntos
FROM TransaccionesReciclaje T
INNER JOIN Materiales M ON T.MaterialId = M.Id
WHERE T.UsuarioId = @UsuarioId AND T.Activo = 1
GROUP BY M.TipoMaterial;

GO

-- ====================================================================
-- CONSULTAS DE ANÁLISIS TEMPORAL
-- ====================================================================

-- Reciclaje por mes (últimos 6 meses)
SELECT 
    YEAR(FechaReciclaje) as Año,
    MONTH(FechaReciclaje) as Mes,
    DATENAME(month, FechaReciclaje) as NombreMes,
    COUNT(*) as TotalTransacciones,
    SUM(CantidadKilos) as TotalKilos,
    SUM(PuntosGanados) as TotalPuntos
FROM TransaccionesReciclaje
WHERE FechaReciclaje >= DATEADD(month, -6, GETDATE()) AND Activo = 1
GROUP BY YEAR(FechaReciclaje), MONTH(FechaReciclaje), DATENAME(month, FechaReciclaje)
ORDER BY Año DESC, Mes DESC;

-- Tendencia de reciclaje semanal
SELECT 
    DATEPART(week, FechaReciclaje) as Semana,
    YEAR(FechaReciclaje) as Año,
    COUNT(*) as TotalTransacciones,
    SUM(CantidadKilos) as TotalKilos
FROM TransaccionesReciclaje
WHERE FechaReciclaje >= DATEADD(month, -3, GETDATE()) AND Activo = 1
GROUP BY DATEPART(week, FechaReciclaje), YEAR(FechaReciclaje)
ORDER BY Año DESC, Semana DESC;

GO

-- ====================================================================
-- CONSULTAS DE ADMINISTRACIÓN
-- ====================================================================

-- Recompensas con bajo stock
SELECT 
    Id,
    Nombre,
    Categoria,
    PuntosRequeridos,
    StockDisponible,
    CASE 
        WHEN StockDisponible = 0 THEN 'AGOTADO'
        WHEN StockDisponible <= 5 THEN 'STOCK CRÍTICO'
        WHEN StockDisponible <= 10 THEN 'STOCK BAJO'
        ELSE 'STOCK OK'
    END as EstadoStock
FROM Recompensas
WHERE Activo = 1
ORDER BY StockDisponible ASC;

-- Usuarios inactivos (sin transacciones en 30 días)
SELECT 
    U.Id,
    U.NombreCompleto,
    U.Email,
    U.PuntosAcumulados,
    MAX(T.FechaReciclaje) as UltimaTransaccion,
    DATEDIFF(day, MAX(T.FechaReciclaje), GETDATE()) as DiasInactivo
FROM Usuarios U
LEFT JOIN TransaccionesReciclaje T ON U.Id = T.UsuarioId
WHERE U.Activo = 1
GROUP BY U.Id, U.NombreCompleto, U.Email, U.PuntosAcumulados
HAVING MAX(T.FechaReciclaje) < DATEADD(day, -30, GETDATE()) OR MAX(T.FechaReciclaje) IS NULL
ORDER BY DiasInactivo DESC;

-- Canjes pendientes de entrega
SELECT 
    C.Id,
    C.FechaCanje,
    U.NombreCompleto,
    U.Email,
    U.Telefono,
    R.Nombre as Recompensa,
    C.EstadoCanje,
    DATEDIFF(day, C.FechaCanje, GETDATE()) as DiasPendiente
FROM CanjesRecompensas C
INNER JOIN Usuarios U ON C.UsuarioId = U.Id
INNER JOIN Recompensas R ON C.RecompensaId = R.Id
WHERE C.EstadoCanje = 'Pendiente' AND C.Activo = 1
ORDER BY C.FechaCanje ASC;

GO

-- ====================================================================
-- CONSULTAS DE VALIDACIÓN Y AUDITORÍA
-- ====================================================================

-- Verificar integridad de puntos de usuarios
SELECT 
    U.Id,
    U.NombreCompleto,
    U.PuntosAcumulados as PuntosActuales,
    ISNULL(SUM(T.PuntosGanados), 0) as PuntosDeTransacciones,
    ISNULL(SUM(C.PuntosUtilizados), 0) as PuntosCanjeados,
    (ISNULL(SUM(T.PuntosGanados), 0) - ISNULL(SUM(C.PuntosUtilizados), 0)) as PuntosCalculados,
    (U.PuntosAcumulados - (ISNULL(SUM(T.PuntosGanados), 0) - ISNULL(SUM(C.PuntosUtilizados), 0))) as Diferencia
FROM Usuarios U
LEFT JOIN TransaccionesReciclaje T ON U.Id = T.UsuarioId AND T.Activo = 1
LEFT JOIN CanjesRecompensas C ON U.Id = C.UsuarioId AND C.Activo = 1
WHERE U.Activo = 1
GROUP BY U.Id, U.NombreCompleto, U.PuntosAcumulados
ORDER BY ABS(U.PuntosAcumulados - (ISNULL(SUM(T.PuntosGanados), 0) - ISNULL(SUM(C.PuntosUtilizados), 0))) DESC;

-- Verificar kilos totales de usuarios
SELECT 
    U.Id,
    U.NombreCompleto,
    U.TotalKilosReciclados as KilosRegistrados,
    ISNULL(SUM(T.CantidadKilos), 0) as KilosDeTransacciones,
    (U.TotalKilosReciclados - ISNULL(SUM(T.CantidadKilos), 0)) as Diferencia
FROM Usuarios U
LEFT JOIN TransaccionesReciclaje T ON U.Id = T.UsuarioId AND T.Activo = 1
WHERE U.Activo = 1
GROUP BY U.Id, U.NombreCompleto, U.TotalKilosReciclados;

GO

PRINT 'Consultas de verificación, estadísticas, análisis y auditoría listas para usar';
GO
