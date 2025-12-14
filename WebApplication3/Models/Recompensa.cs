using System;
using WebApplication3.Models.Base;

namespace WebApplication3.Models
{
    /// <summary>
    /// Recompensa canjeable
    /// </summary>
    public class Recompensa : EntidadBase
    {
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public decimal PuntosRequeridos { get; set; }
        public int StockDisponible { get; set; }
        public string ImagenUrl { get; set; }
        public string Categoria { get; set; }

        public bool TieneStock()
        {
            return StockDisponible > 0;
        }

        public void ReducirStock()
        {
            if (StockDisponible > 0)
            {
                StockDisponible--;
                Actualizar();
            }
        }
    }
}
