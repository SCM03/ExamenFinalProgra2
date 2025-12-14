using System;
using WebApplication3.Models.Interfaces;

namespace WebApplication3.Models.Base
{
    /// <summary>
    /// Clase base abstracta para todas las entidades
    /// </summary>
    public abstract class EntidadBase : IEntidadBase
    {
        public int Id { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime? FechaModificacion { get; set; }
        public bool Activo { get; set; }

        protected EntidadBase()
        {
            FechaCreacion = DateTime.Now;
            Activo = true;
        }

        public virtual void Actualizar()
        {
            FechaModificacion = DateTime.Now;
        }

        public virtual void Desactivar()
        {
            Activo = false;
            FechaModificacion = DateTime.Now;
        }
    }
}
