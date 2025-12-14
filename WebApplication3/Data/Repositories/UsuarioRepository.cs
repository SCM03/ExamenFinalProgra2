using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;

namespace WebApplication3.Data.Repositories
{
    /// <summary>
    /// Repositorio para operaciones CRUD de Usuario
    /// </summary>
    public class UsuarioRepository
    {
        private readonly DatabaseHelper _db;

        public UsuarioRepository()
        {
            _db = new DatabaseHelper();
        }

        public Usuario ObtenerPorId(int id)
        {
            string query = "SELECT * FROM Usuarios WHERE Id = @Id AND Activo = 1";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@Id", id));

            if (dt.Rows.Count > 0)
                return MapearUsuario(dt.Rows[0]);

            return null;
        }

        public Usuario ObtenerPorEmail(string email)
        {
            string query = "SELECT * FROM Usuarios WHERE Email = @Email AND Activo = 1";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@Email", email));

            if (dt.Rows.Count > 0)
                return MapearUsuario(dt.Rows[0]);

            return null;
        }

        public Usuario ValidarLogin(string email, string password)
        {
            string query = "SELECT * FROM Usuarios WHERE Email = @Email AND Password = @Password AND Activo = 1";
            var dt = _db.ExecuteQuery(query, 
                new SqlParameter("@Email", email),
                new SqlParameter("@Password", password));

            if (dt.Rows.Count > 0)
                return MapearUsuario(dt.Rows[0]);

            return null;
        }

        public List<Usuario> ObtenerTodos()
        {
            string query = "SELECT * FROM Usuarios WHERE Activo = 1 ORDER BY PuntosAcumulados DESC";
            var dt = _db.ExecuteQuery(query);
            var usuarios = new List<Usuario>();

            foreach (DataRow row in dt.Rows)
            {
                usuarios.Add(MapearUsuario(row));
            }

            return usuarios;
        }

        public int Insertar(Usuario usuario)
        {
            string query = @"INSERT INTO Usuarios (NombreCompleto, Email, Password, Telefono, Direccion, 
                            PuntosAcumulados, TotalReciclajesRealizados, TotalKilosReciclados, FechaCreacion, Activo)
                            VALUES (@NombreCompleto, @Email, @Password, @Telefono, @Direccion, 
                            @PuntosAcumulados, @TotalReciclajesRealizados, @TotalKilosReciclados, @FechaCreacion, @Activo);
                            SELECT CAST(SCOPE_IDENTITY() as int)";

            return _db.ExecuteScalar<int>(query,
                new SqlParameter("@NombreCompleto", usuario.NombreCompleto),
                new SqlParameter("@Email", usuario.Email),
                new SqlParameter("@Password", usuario.Password),
                new SqlParameter("@Telefono", usuario.Telefono ?? (object)DBNull.Value),
                new SqlParameter("@Direccion", usuario.Direccion ?? (object)DBNull.Value),
                new SqlParameter("@PuntosAcumulados", usuario.PuntosAcumulados),
                new SqlParameter("@TotalReciclajesRealizados", usuario.TotalReciclajesRealizados),
                new SqlParameter("@TotalKilosReciclados", usuario.TotalKilosReciclados),
                new SqlParameter("@FechaCreacion", usuario.FechaCreacion),
                new SqlParameter("@Activo", usuario.Activo));
        }

        public bool Actualizar(Usuario usuario)
        {
            string query = @"UPDATE Usuarios SET 
                            NombreCompleto = @NombreCompleto,
                            Email = @Email,
                            Telefono = @Telefono,
                            Direccion = @Direccion,
                            PuntosAcumulados = @PuntosAcumulados,
                            TotalReciclajesRealizados = @TotalReciclajesRealizados,
                            TotalKilosReciclados = @TotalKilosReciclados,
                            FechaModificacion = @FechaModificacion
                            WHERE Id = @Id";

            int rowsAffected = _db.ExecuteNonQuery(query,
                new SqlParameter("@Id", usuario.Id),
                new SqlParameter("@NombreCompleto", usuario.NombreCompleto),
                new SqlParameter("@Email", usuario.Email),
                new SqlParameter("@Telefono", usuario.Telefono ?? (object)DBNull.Value),
                new SqlParameter("@Direccion", usuario.Direccion ?? (object)DBNull.Value),
                new SqlParameter("@PuntosAcumulados", usuario.PuntosAcumulados),
                new SqlParameter("@TotalReciclajesRealizados", usuario.TotalReciclajesRealizados),
                new SqlParameter("@TotalKilosReciclados", usuario.TotalKilosReciclados),
                new SqlParameter("@FechaModificacion", DateTime.Now));

            return rowsAffected > 0;
        }

        private Usuario MapearUsuario(DataRow row)
        {
            return new Usuario
            {
                Id = Convert.ToInt32(row["Id"]),
                NombreCompleto = row["NombreCompleto"].ToString(),
                Email = row["Email"].ToString(),
                Password = row["Password"].ToString(),
                Telefono = row["Telefono"] != DBNull.Value ? row["Telefono"].ToString() : null,
                Direccion = row["Direccion"] != DBNull.Value ? row["Direccion"].ToString() : null,
                PuntosAcumulados = Convert.ToDecimal(row["PuntosAcumulados"]),
                TotalReciclajesRealizados = Convert.ToInt32(row["TotalReciclajesRealizados"]),
                TotalKilosReciclados = Convert.ToDecimal(row["TotalKilosReciclados"]),
                FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                FechaModificacion = row["FechaModificacion"] != DBNull.Value ? Convert.ToDateTime(row["FechaModificacion"]) : (DateTime?)null,
                Activo = Convert.ToBoolean(row["Activo"])
            };
        }
    }
}
