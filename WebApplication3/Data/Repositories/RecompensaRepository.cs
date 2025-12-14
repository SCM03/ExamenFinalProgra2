using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;

namespace WebApplication3.Data.Repositories
{
    /// <summary>
    /// Repositorio para recompensas
    /// </summary>
    public class RecompensaRepository
    {
        private readonly DatabaseHelper _db;

        public RecompensaRepository()
        {
            _db = new DatabaseHelper();
        }

        public Recompensa ObtenerPorId(int id)
        {
            string query = "SELECT * FROM Recompensas WHERE Id = @Id AND Activo = 1";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@Id", id));

            if (dt.Rows.Count > 0)
                return MapearRecompensa(dt.Rows[0]);

            return null;
        }

        public List<Recompensa> ObtenerTodas()
        {
            string query = "SELECT * FROM Recompensas WHERE Activo = 1 ORDER BY PuntosRequeridos";
            var dt = _db.ExecuteQuery(query);
            var recompensas = new List<Recompensa>();

            foreach (DataRow row in dt.Rows)
            {
                recompensas.Add(MapearRecompensa(row));
            }

            return recompensas;
        }

        public List<Recompensa> ObtenerDisponibles()
        {
            string query = "SELECT * FROM Recompensas WHERE Activo = 1 AND StockDisponible > 0 ORDER BY PuntosRequeridos";
            var dt = _db.ExecuteQuery(query);
            var recompensas = new List<Recompensa>();

            foreach (DataRow row in dt.Rows)
            {
                recompensas.Add(MapearRecompensa(row));
            }

            return recompensas;
        }

        public bool ActualizarStock(int id, int nuevoStock)
        {
            string query = "UPDATE Recompensas SET StockDisponible = @Stock, FechaModificacion = @Fecha WHERE Id = @Id";
            int rowsAffected = _db.ExecuteNonQuery(query,
                new SqlParameter("@Id", id),
                new SqlParameter("@Stock", nuevoStock),
                new SqlParameter("@Fecha", DateTime.Now));

            return rowsAffected > 0;
        }

        private Recompensa MapearRecompensa(DataRow row)
        {
            return new Recompensa
            {
                Id = Convert.ToInt32(row["Id"]),
                Nombre = row["Nombre"].ToString(),
                Descripcion = row["Descripcion"] != DBNull.Value ? row["Descripcion"].ToString() : null,
                PuntosRequeridos = Convert.ToDecimal(row["PuntosRequeridos"]),
                StockDisponible = Convert.ToInt32(row["StockDisponible"]),
                ImagenUrl = row["ImagenUrl"] != DBNull.Value ? row["ImagenUrl"].ToString() : null,
                Categoria = row["Categoria"] != DBNull.Value ? row["Categoria"].ToString() : null,
                FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                Activo = Convert.ToBoolean(row["Activo"])
            };
        }
    }
}
