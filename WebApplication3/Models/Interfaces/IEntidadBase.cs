using System;

namespace WebApplication3.Models.Interfaces
{
    /// <summary>
    /// Interfaz base para todas las entidades del sistema
    /// </summary>
    public interface IEntidadBase
    {
        int Id { get; set; }
        DateTime FechaCreacion { get; set; }
        DateTime? FechaModificacion { get; set; }
        bool Activo { get; set; }
    }
}
