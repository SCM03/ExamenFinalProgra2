using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;

namespace WebApplication3.Data.Repositories
{
    /// <summary>
    /// Repositorio para transacciones de reciclaje
    /// </summary>
    public class TransaccionReciclajeRepository
    {
        private readonly DatabaseHelper _db;
        private readonly UsuarioRepository _usuarioRepo;
        private readonly MaterialRepository _materialRepo;

        public TransaccionReciclajeRepository()
        {
            _db = new DatabaseHelper();
            _usuarioRepo = new UsuarioRepository();
            _materialRepo = new MaterialRepository();
        }

        public List<TransaccionReciclaje> ObtenerPorUsuario(int usuarioId)
        {
            string query = @"SELECT * FROM TransaccionesReciclaje 
                            WHERE UsuarioId = @UsuarioId AND Activo = 1 
                            ORDER BY FechaReciclaje DESC";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@UsuarioId", usuarioId));
            var transacciones = new List<TransaccionReciclaje>();

            foreach (DataRow row in dt.Rows)
            {
                transacciones.Add(MapearTransaccion(row));
            }

            return transacciones;
        }

        public List<TransaccionReciclaje> ObtenerTodas()
        {
            string query = "SELECT * FROM TransaccionesReciclaje WHERE Activo = 1 ORDER BY FechaReciclaje DESC";
            var dt = _db.ExecuteQuery(query);
            var transacciones = new List<TransaccionReciclaje>();

            foreach (DataRow row in dt.Rows)
            {
                transacciones.Add(MapearTransaccion(row));
            }

            return transacciones;
        }

        public int Insertar(TransaccionReciclaje transaccion)
        {
            string query = @"INSERT INTO TransaccionesReciclaje (UsuarioId, MaterialId, CantidadKilos, 
                            PuntosGanados, Observaciones, FechaReciclaje, FechaCreacion, Activo)
                            VALUES (@UsuarioId, @MaterialId, @CantidadKilos, 
                            @PuntosGanados, @Observaciones, @FechaReciclaje, @FechaCreacion, @Activo);
                            SELECT CAST(SCOPE_IDENTITY() as int)";

            return _db.ExecuteScalar<int>(query,
                new SqlParameter("@UsuarioId", transaccion.UsuarioId),
                new SqlParameter("@MaterialId", transaccion.MaterialId),
                new SqlParameter("@CantidadKilos", transaccion.CantidadKilos),
                new SqlParameter("@PuntosGanados", transaccion.PuntosGanados),
                new SqlParameter("@Observaciones", transaccion.Observaciones ?? (object)DBNull.Value),
                new SqlParameter("@FechaReciclaje", transaccion.FechaReciclaje),
                new SqlParameter("@FechaCreacion", transaccion.FechaCreacion),
                new SqlParameter("@Activo", transaccion.Activo));
        }

        public DataTable ObtenerEstadisticasGenerales()
        {
            string query = @"SELECT 
                            COUNT(DISTINCT UsuarioId) as TotalUsuarios,
                            COUNT(*) as TotalTransacciones,
                            SUM(CantidadKilos) as TotalKilosReciclados,
                            SUM(PuntosGanados) as TotalPuntosGenerados
                            FROM TransaccionesReciclaje 
                            WHERE Activo = 1";

            return _db.ExecuteQuery(query);
        }

        public DataTable ObtenerEstadisticasPorMaterial()
        {
            string query = @"SELECT 
                            M.Nombre as Material,
                            M.TipoMaterial,
                            COUNT(*) as TotalTransacciones,
                            SUM(T.CantidadKilos) as TotalKilos,
                            SUM(T.PuntosGanados) as TotalPuntos
                            FROM TransaccionesReciclaje T
                            INNER JOIN Materiales M ON T.MaterialId = M.Id
                            WHERE T.Activo = 1
                            GROUP BY M.Nombre, M.TipoMaterial
                            ORDER BY TotalKilos DESC";

            return _db.ExecuteQuery(query);
        }

        private TransaccionReciclaje MapearTransaccion(DataRow row)
        {
            return new TransaccionReciclaje
            {
                Id = Convert.ToInt32(row["Id"]),
                UsuarioId = Convert.ToInt32(row["UsuarioId"]),
                MaterialId = Convert.ToInt32(row["MaterialId"]),
                CantidadKilos = Convert.ToDecimal(row["CantidadKilos"]),
                PuntosGanados = Convert.ToDecimal(row["PuntosGanados"]),
                Observaciones = row["Observaciones"] != DBNull.Value ? row["Observaciones"].ToString() : null,
                FechaReciclaje = Convert.ToDateTime(row["FechaReciclaje"]),
                FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                Activo = Convert.ToBoolean(row["Activo"])
            };
        }
    }
}
