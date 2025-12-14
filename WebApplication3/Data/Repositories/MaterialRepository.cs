using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;
using WebApplication3.Models.Base;

namespace WebApplication3.Data.Repositories
{
    /// <summary>
    /// Repositorio para operaciones CRUD de Materiales (Polimorfismo en acción)
    /// </summary>
    public class MaterialRepository
    {
        private readonly DatabaseHelper _db;

        public MaterialRepository()
        {
            _db = new DatabaseHelper();
        }

        public MaterialBase ObtenerPorId(int id)
        {
            string query = "SELECT * FROM Materiales WHERE Id = @Id AND Activo = 1";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@Id", id));

            if (dt.Rows.Count > 0)
                return MapearMaterial(dt.Rows[0]);

            return null;
        }

        public List<MaterialBase> ObtenerTodos()
        {
            string query = "SELECT * FROM Materiales WHERE Activo = 1 ORDER BY TipoMaterial, Nombre";
            var dt = _db.ExecuteQuery(query);
            var materiales = new List<MaterialBase>();

            foreach (DataRow row in dt.Rows)
            {
                materiales.Add(MapearMaterial(row));
            }

            return materiales;
        }

        public List<MaterialBase> ObtenerPorTipo(string tipo)
        {
            string query = "SELECT * FROM Materiales WHERE TipoMaterial = @Tipo AND Activo = 1";
            var dt = _db.ExecuteQuery(query, new SqlParameter("@Tipo", tipo));
            var materiales = new List<MaterialBase>();

            foreach (DataRow row in dt.Rows)
            {
                materiales.Add(MapearMaterial(row));
            }

            return materiales;
        }

        public int Insertar(MaterialBase material)
        {
            string query = @"INSERT INTO Materiales (Nombre, TipoMaterial, PuntosPorKilo, Descripcion, 
                            SubCategoria, EsCompostable, RequiereLimpiezaPrevia, TiempoDescomposicion, 
                            FechaCreacion, Activo)
                            VALUES (@Nombre, @TipoMaterial, @PuntosPorKilo, @Descripcion, 
                            @SubCategoria, @EsCompostable, @RequiereLimpiezaPrevia, @TiempoDescomposicion, 
                            @FechaCreacion, @Activo);
                            SELECT CAST(SCOPE_IDENTITY() as int)";

            var organico = material as MaterialOrganico;
            var inorganico = material as MaterialInorganico;

            return _db.ExecuteScalar<int>(query,
                new SqlParameter("@Nombre", material.Nombre),
                new SqlParameter("@TipoMaterial", material.TipoMaterial),
                new SqlParameter("@PuntosPorKilo", material.PuntosPorKilo),
                new SqlParameter("@Descripcion", material.Descripcion ?? (object)DBNull.Value),
                new SqlParameter("@SubCategoria", inorganico?.SubCategoria ?? (object)DBNull.Value),
                new SqlParameter("@EsCompostable", organico?.EsCompostable ?? (object)DBNull.Value),
                new SqlParameter("@RequiereLimpiezaPrevia", inorganico?.RequiereLimpiezaPrevia ?? (object)DBNull.Value),
                new SqlParameter("@TiempoDescomposicion", 
                    organico?.TiempoDescomposicion ?? inorganico?.TiempoDescomposicionNatural ?? (object)DBNull.Value),
                new SqlParameter("@FechaCreacion", material.FechaCreacion),
                new SqlParameter("@Activo", material.Activo));
        }

        // Mapeo polimórfico: retorna MaterialOrganico o MaterialInorganico según el tipo
        private MaterialBase MapearMaterial(DataRow row)
        {
            string tipoMaterial = row["TipoMaterial"].ToString();

            if (tipoMaterial == "Orgánico")
            {
                return new MaterialOrganico
                {
                    Id = Convert.ToInt32(row["Id"]),
                    Nombre = row["Nombre"].ToString(),
                    TipoMaterial = tipoMaterial,
                    PuntosPorKilo = Convert.ToDecimal(row["PuntosPorKilo"]),
                    Descripcion = row["Descripcion"] != DBNull.Value ? row["Descripcion"].ToString() : null,
                    EsCompostable = row["EsCompostable"] != DBNull.Value && Convert.ToBoolean(row["EsCompostable"]),
                    TiempoDescomposicion = row["TiempoDescomposicion"] != DBNull.Value ? Convert.ToInt32(row["TiempoDescomposicion"]) : 0,
                    FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                    FechaModificacion = row["FechaModificacion"] != DBNull.Value ? Convert.ToDateTime(row["FechaModificacion"]) : (DateTime?)null,
                    Activo = Convert.ToBoolean(row["Activo"])
                };
            }
            else
            {
                return new MaterialInorganico
                {
                    Id = Convert.ToInt32(row["Id"]),
                    Nombre = row["Nombre"].ToString(),
                    TipoMaterial = tipoMaterial,
                    PuntosPorKilo = Convert.ToDecimal(row["PuntosPorKilo"]),
                    Descripcion = row["Descripcion"] != DBNull.Value ? row["Descripcion"].ToString() : null,
                    SubCategoria = row["SubCategoria"] != DBNull.Value ? row["SubCategoria"].ToString() : null,
                    RequiereLimpiezaPrevia = row["RequiereLimpiezaPrevia"] != DBNull.Value && Convert.ToBoolean(row["RequiereLimpiezaPrevia"]),
                    TiempoDescomposicionNatural = row["TiempoDescomposicion"] != DBNull.Value ? Convert.ToInt32(row["TiempoDescomposicion"]) : 0,
                    FechaCreacion = Convert.ToDateTime(row["FechaCreacion"]),
                    FechaModificacion = row["FechaModificacion"] != DBNull.Value ? Convert.ToDateTime(row["FechaModificacion"]) : (DateTime?)null,
                    Activo = Convert.ToBoolean(row["Activo"])
                };
            }
        }
    }
}
