-- ====================================================================
-- DATOS INICIALES PARA SISTEMA DE GESTIÓN DE RECICLAJE
-- ====================================================================

USE ReciclajeDB;
GO

-- ====================================================================
-- INSERCIÓN DE MATERIALES ORGÁNICOS
-- ====================================================================

-- Materiales Orgánicos Compostables
INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Restos de Frutas', 'Orgánico', 10, 'Cáscaras y restos de frutas frescas', 1, NULL, NULL, 14),
('Restos de Verduras', 'Orgánico', 10, 'Restos de vegetales y hortalizas', 1, NULL, NULL, 14),
('Cáscaras de Huevo', 'Orgánico', 8, 'Cáscaras de huevo trituradas, excelentes para compost', 1, NULL, NULL, 30),
('Residuos de Café', 'Orgánico', 12, 'Posos de café y filtros de papel', 1, NULL, NULL, 7),
('Hojas Secas', 'Orgánico', 5, 'Hojas caídas de árboles y plantas', 1, NULL, NULL, 60),
('Restos de Jardín', 'Orgánico', 8, 'Ramas pequeñas, flores marchitas, césped cortado', 1, NULL, NULL, 30);

-- Materiales Orgánicos No Compostables
INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Papel Sucio', 'Orgánico', 5, 'Papel con restos de comida (servilletas, papel absorbente usado)', 0, NULL, NULL, 90),
('Cartón Encerado', 'Orgánico', 3, 'Cartón con cera o plastificado', 0, NULL, NULL, 180);

GO

-- ====================================================================
-- INSERCIÓN DE MATERIALES INORGÁNICOS - PLÁSTICO
-- ====================================================================

INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Botellas PET', 'Inorgánico', 15, 'Botellas de plástico PET transparente (código 1)', NULL, 'Plástico', 1, 450),
('Envases HDPE', 'Inorgánico', 12, 'Envases de plástico duro (código 2) como botellas de leche', NULL, 'Plástico', 1, 400),
('Bolsas Plásticas', 'Inorgánico', 8, 'Bolsas de supermercado limpias y secas', NULL, 'Plástico', 1, 500),
('Envases de Yogurt', 'Inorgánico', 10, 'Envases plásticos de yogurt y lácteos', NULL, 'Plástico', 1, 400),
('Tapas Plásticas', 'Inorgánico', 10, 'Tapas de botellas y envases plásticos', NULL, 'Plástico', 0, 450);

GO

-- ====================================================================
-- INSERCIÓN DE MATERIALES INORGÁNICOS - VIDRIO
-- ====================================================================

INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Botellas de Vidrio', 'Inorgánico', 20, 'Botellas de vidrio transparente o de color', NULL, 'Vidrio', 1, 4000),
('Frascos de Vidrio', 'Inorgánico', 18, 'Frascos de conservas, mermeladas, etc.', NULL, 'Vidrio', 1, 4000),
('Vasos de Vidrio', 'Inorgánico', 15, 'Vasos y copas de vidrio', NULL, 'Vidrio', 1, 4000);

GO

-- ====================================================================
-- INSERCIÓN DE MATERIALES INORGÁNICOS - METAL
-- ====================================================================

INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Latas de Aluminio', 'Inorgánico', 25, 'Latas de bebidas de aluminio', NULL, 'Metal', 1, 200),
('Latas de Acero', 'Inorgánico', 20, 'Latas de conservas de acero', NULL, 'Metal', 1, 100),
('Tapas Metálicas', 'Inorgánico', 18, 'Tapas de frascos y botellas de metal', NULL, 'Metal', 1, 100),
('Papel Aluminio', 'Inorgánico', 15, 'Papel aluminio limpio y sin restos de comida', NULL, 'Metal', 1, 200);

GO

-- ====================================================================
-- INSERCIÓN DE MATERIALES INORGÁNICOS - PAPEL Y CARTÓN
-- ====================================================================

INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, EsCompostable, SubCategoria, RequiereLimpiezaPrevia, TiempoDescomposicion)
VALUES 
('Papel Blanco', 'Inorgánico', 12, 'Hojas de papel blanco de oficina', NULL, 'Papel', 0, 1),
('Periódicos', 'Inorgánico', 10, 'Periódicos y revistas', NULL, 'Papel', 0, 1),
('Cartón Corrugado', 'Inorgánico', 15, 'Cajas de cartón corrugado', NULL, 'Papel', 0, 2),
('Cuadernos y Libros', 'Inorgánico', 11, 'Cuadernos, libros y folletos', NULL, 'Papel', 0, 1),
('Sobres', 'Inorgánico', 10, 'Sobres de papel sin ventana plástica', NULL, 'Papel', 0, 1);

GO

-- ====================================================================
-- INSERCIÓN DE RECOMPENSAS
-- ====================================================================

INSERT INTO Recompensas (Nombre, Descripcion, PuntosRequeridos, StockDisponible, Categoria)
VALUES 
-- Recompensas Nivel Principiante (500-1000 puntos)
('Bolsa Reutilizable Ecológica', 'Bolsa de tela resistente para compras, 100% algodón orgánico', 500, 50, 'Accesorios'),
('Botella de Agua Reutilizable', 'Botella térmica de acero inoxidable 500ml', 700, 40, 'Accesorios'),
('Set de Bombillas Reutilizables', 'Pack de 4 bombillas de acero inoxidable con cepillo limpiador', 600, 35, 'Accesorios'),
('Cuaderno Reciclado', 'Cuaderno de 100 hojas elaborado con papel 100% reciclado', 450, 60, 'Papelería'),

-- Recompensas Nivel Bronce (1000-2000 puntos)
('Kit de Cultivo Urbano', 'Kit completo para iniciar tu huerto en casa con semillas orgánicas', 1200, 25, 'Jardinería'),
('Compostador Doméstico', 'Contenedor para hacer compost en casa, capacidad 10 litros', 1500, 20, 'Jardinería'),
('Termo Inteligente', 'Termo de 750ml que mantiene temperatura por 12 horas', 1300, 30, 'Accesorios'),
('Pack de Contenedores Herméticos', 'Set de 5 contenedores de vidrio para almacenar alimentos', 1400, 25, 'Hogar'),

-- Recompensas Nivel Plata (2000-5000 puntos)
('Bicicleta Plegable Urbana', 'Bicicleta plegable ideal para transporte urbano sostenible', 4500, 10, 'Transporte'),
('Panel Solar Portátil', 'Cargador solar de 20W para dispositivos móviles', 3000, 15, 'Tecnología'),
('Kit de Jardinería Completo', 'Herramientas de jardinería de alta calidad en caja de madera', 2500, 20, 'Jardinería'),
('Purificador de Agua Portátil', 'Sistema de filtración de agua para uso doméstico', 3500, 12, 'Hogar'),

-- Recompensas Nivel Oro (5000-10000 puntos)
('Scooter Eléctrico', 'Scooter eléctrico plegable con autonomía de 25km', 8000, 5, 'Transporte'),
('Sistema de Riego por Goteo', 'Sistema automatizado de riego para jardín o huerto', 6000, 8, 'Jardinería'),
('Generador Solar Portátil', 'Generador de energía solar de 150W con batería incorporada', 7500, 6, 'Tecnología'),
('Compostador Giratorio Premium', 'Compostador de gran capacidad con sistema giratorio', 5500, 10, 'Jardinería'),

-- Recompensas Nivel Diamante (10000+ puntos)
('Kit Solar para Hogar', 'Sistema de paneles solares básico para uso doméstico', 15000, 3, 'Tecnología'),
('Bicicleta Eléctrica', 'Bicicleta eléctrica de montaña con batería de larga duración', 18000, 2, 'Transporte'),
('Sistema de Captación de Agua de Lluvia', 'Sistema completo para recolectar y filtrar agua de lluvia', 12000, 4, 'Hogar'),
('Curso Online de Permacultura', 'Curso certificado de 3 meses sobre diseño de permacultura', 10000, 50, 'Educación');

GO

-- ====================================================================
-- INSERCIÓN DE USUARIOS DE EJEMPLO
-- ====================================================================

-- Usuario 1: Usuario Activo
INSERT INTO Usuarios (NombreCompleto, Email, Password, Telefono, Direccion, PuntosAcumulados, TotalReciclajesRealizados, TotalKilosReciclados)
VALUES 
('María González', 'maria.gonzalez@example.com', '123456', '+56912345678', 'Av. Principal 123, Santiago', 3500, 25, 125.50);

-- Usuario 2: Usuario Nuevo
INSERT INTO Usuarios (NombreCompleto, Email, Password, Telefono, Direccion)
VALUES 
('Juan Pérez', 'juan.perez@example.com', '123456', '+56987654321', 'Calle Secundaria 456, Valparaíso');

-- Usuario 3: Usuario Avanzado
INSERT INTO Usuarios (NombreCompleto, Email, Password, Telefono, Direccion, PuntosAcumulados, TotalReciclajesRealizados, TotalKilosReciclados)
VALUES 
('Ana Martínez', 'ana.martinez@example.com', '123456', '+56911223344', 'Pasaje Verde 789, Concepción', 8750, 58, 356.80);

-- Usuario 4: Usuario Admin/Demo
INSERT INTO Usuarios (NombreCompleto, Email, Password, Telefono, Direccion, PuntosAcumulados, TotalReciclajesRealizados, TotalKilosReciclados)
VALUES 
('Admin Sistema', 'admin@reciclaje.com', 'admin123', '+56900000000', 'Oficina Central', 15000, 100, 580.25);

GO

-- ====================================================================
-- INSERCIÓN DE TRANSACCIONES DE EJEMPLO
-- ====================================================================

-- Transacciones para María González
INSERT INTO TransaccionesReciclaje (UsuarioId, MaterialId, CantidadKilos, PuntosGanados, Observaciones, FechaReciclaje)
VALUES 
(1, 1, 2.5, 25, 'Restos de preparación de ensaladas', DATEADD(day, -15, GETDATE())),
(1, 9, 1.0, 15, 'Botellas PET de bebidas', DATEADD(day, -14, GETDATE())),
(1, 14, 3.0, 60, 'Botellas de vidrio de jugos', DATEADD(day, -10, GETDATE())),
(1, 18, 2.0, 50, 'Latas de bebidas', DATEADD(day, -8, GETDATE())),
(1, 22, 5.0, 60, 'Cajas de cartón de delivery', DATEADD(day, -5, GETDATE()));

-- Transacciones para Ana Martínez
INSERT INTO TransaccionesReciclaje (UsuarioId, MaterialId, CantidadKilos, PuntosGanados, Observaciones, FechaReciclaje)
VALUES 
(3, 4, 1.5, 18, 'Posos de café de la semana', DATEADD(day, -20, GETDATE())),
(3, 18, 5.0, 125, 'Recolección mensual de latas', DATEADD(day, -18, GETDATE())),
(3, 14, 4.0, 80, 'Frascos de conservas', DATEADD(day, -15, GETDATE())),
(3, 9, 8.0, 120, 'Botellas plásticas del mes', DATEADD(day, -12, GETDATE())),
(3, 22, 10.0, 150, 'Papel y cartón de oficina', DATEADD(day, -7, GETDATE()));

-- Transacciones para Admin
INSERT INTO TransaccionesReciclaje (UsuarioId, MaterialId, CantidadKilos, PuntosGanados, Observaciones, FechaReciclaje)
VALUES 
(4, 1, 10.0, 100, 'Recolección comunitaria', DATEADD(day, -25, GETDATE())),
(4, 9, 15.0, 225, 'Campaña de reciclaje escolar', DATEADD(day, -22, GETDATE())),
(4, 18, 12.0, 300, 'Evento de reciclaje comunitario', DATEADD(day, -18, GETDATE())),
(4, 14, 8.0, 160, 'Reciclaje de vidrio mensual', DATEADD(day, -15, GETDATE())),
(4, 22, 20.0, 300, 'Papel de oficinas', DATEADD(day, -10, GETDATE()));

GO

-- ====================================================================
-- INSERCIÓN DE CANJES DE EJEMPLO
-- ====================================================================

INSERT INTO CanjesRecompensas (UsuarioId, RecompensaId, PuntosUtilizados, EstadoCanje, FechaCanje)
VALUES 
(1, 1, 500, 'Entregado', DATEADD(day, -12, GETDATE())),
(3, 11, 2500, 'Entregado', DATEADD(day, -20, GETDATE())),
(3, 7, 1300, 'Pendiente', DATEADD(day, -5, GETDATE())),
(4, 15, 6000, 'Entregado', DATEADD(day, -30, GETDATE()));

GO

-- ====================================================================
-- ACTUALIZAR STOCK DE RECOMPENSAS CANJEADAS
-- ====================================================================

UPDATE Recompensas SET StockDisponible = StockDisponible - 1 WHERE Id = 1;
UPDATE Recompensas SET StockDisponible = StockDisponible - 1 WHERE Id = 11;
UPDATE Recompensas SET StockDisponible = StockDisponible - 1 WHERE Id = 7;
UPDATE Recompensas SET StockDisponible = StockDisponible - 1 WHERE Id = 15;

GO

PRINT 'Datos iniciales insertados exitosamente';
PRINT '==========================================';
PRINT 'USUARIOS CREADOS:';
PRINT '- maria.gonzalez@example.com / 123456';
PRINT '- juan.perez@example.com / 123456';
PRINT '- ana.martinez@example.com / 123456';
PRINT '- admin@reciclaje.com / admin123';
PRINT '==========================================';
PRINT 'Total Materiales: 26';
PRINT 'Total Recompensas: 20';
PRINT 'Total Usuarios: 4';
PRINT 'Total Transacciones: 15';
PRINT 'Total Canjes: 4';
PRINT '==========================================';
GO
