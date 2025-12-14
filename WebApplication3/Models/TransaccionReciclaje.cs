using System;
using WebApplication3.Models.Base;

namespace WebApplication3.Models
{
    /// <summary>
    /// Transacción de reciclaje
    /// </summary>
    public class TransaccionReciclaje : EntidadBase
    {
        public int UsuarioId { get; set; }
        public int MaterialId { get; set; }
        public decimal CantidadKilos { get; set; }
        public decimal PuntosGanados { get; set; }
        public string Observaciones { get; set; }
        public DateTime FechaReciclaje { get; set; }

        // Propiedades de navegación (no se mapean en DB)
        public Usuario Usuario { get; set; }
        public MaterialBase Material { get; set; }

        public TransaccionReciclaje()
        {
            FechaReciclaje = DateTime.Now;
        }
    }
}
