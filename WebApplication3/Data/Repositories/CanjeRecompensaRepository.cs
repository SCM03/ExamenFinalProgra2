using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;

namespace WebApplication3.Data.Repositories
{
    /// <summary>
    /// Repositorio para canjes de recompensas
    /// </summary>
    public class CanjeRecompensaRepository
    {
        private readonly DatabaseHelper _db;

        public CanjeRecompensaRepository()
        {
            _db = new DatabaseHelper();
        }

        public List<CanjeRecompensa> ObtenerPorUsuario(int usuarioId)
        {
            string query = @"SELECT * FROM CanjesRecompensas 
                            WHERE UsuarioId = @UsuarioId AND Activo = 1 
                            ORDER BY FechaCanje DESC";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@UsuarioId", usuarioId));
            var canjes = new List<CanjeRecompensa>();

            foreach (DataRow row in dt.Rows)
            {
                canjes.Add(MapearCanje(row));
            }

            return canjes;
        }

        public int Insertar(CanjeRecompensa canje)
        {
            string query = @"INSERT INTO CanjesRecompensas (UsuarioId, RecompensaId, PuntosUtilizados, 
                            FechaCanje, EstadoCanje, FechaCreacion, Activo)
                            VALUES (@UsuarioId, @RecompensaId, @PuntosUtilizados, 
                            @FechaCanje, @EstadoCanje, @FechaCreacion, @Activo);
                            SELECT CAST(SCOPE_IDENTITY() as int)";

            return _db.ExecuteScalar<int>(query,
                new SqlParameter("@UsuarioId", canje.UsuarioId),
                new SqlParameter("@RecompensaId", canje.RecompensaId),
                new SqlParameter("@PuntosUtilizados", canje.PuntosUtilizados),
                new SqlParameter("@FechaCanje", canje.FechaCanje),
                new SqlParameter("@EstadoCanje", canje.EstadoCanje),
                new SqlParameter("@FechaCreacion", canje.FechaCreacion),
                new SqlParameter("@Activo", canje.Activo));
        }

        private CanjeRecompensa MapearCanje(DataRow row)
        {
            return new CanjeRecompensa
            {
                Id = Convert.ToInt32(row["Id"]),
                UsuarioId = Convert.ToInt32(row["UsuarioId"]),
                RecompensaId = Convert.ToInt32(row["RecompensaId"]),
                PuntosUtilizados = Convert.ToDecimal(row["PuntosUtilizados"]),
                FechaCanje = Convert.ToDateTime(row["FechaCanje"]),
                EstadoCanje = row["EstadoCanje"].ToString(),
                FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                Activo = Convert.ToBoolean(row["Activo"])
            };
        }
    }
}
