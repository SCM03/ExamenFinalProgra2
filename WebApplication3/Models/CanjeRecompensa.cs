using System;
using WebApplication3.Models.Base;

namespace WebApplication3.Models
{
    /// <summary>
    /// Canje de recompensa por usuario
    /// </summary>
    public class CanjeRecompensa : EntidadBase
    {
        public int UsuarioId { get; set; }
        public int RecompensaId { get; set; }
        public decimal PuntosUtilizados { get; set; }
        public DateTime FechaCanje { get; set; }
        public string EstadoCanje { get; set; } // Pendiente, Entregado, Cancelado

        // Propiedades de navegación
        public Usuario Usuario { get; set; }
        public Recompensa Recompensa { get; set; }

        public CanjeRecompensa()
        {
            FechaCanje = DateTime.Now;
            EstadoCanje = "Pendiente";
        }
    }
}
