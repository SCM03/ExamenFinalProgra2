using WebApplication3.Models.Interfaces;

namespace WebApplication3.Models.Base
{
    /// <summary>
    /// Clase base abstracta para materiales reciclables con polimorfismo
    /// </summary>
    public abstract class MaterialBase : EntidadBase, IMaterial, IReciclable
    {
        public string Nombre { get; set; }
        public string TipoMaterial { get; set; }
        public decimal PuntosPorKilo { get; set; }
        public string Descripcion { get; set; }

        // Método virtual que puede ser sobreescrito por clases derivadas (Polimorfismo)
        public virtual decimal CalcularPuntos(decimal cantidad)
        {
            return cantidad * PuntosPorKilo;
        }

        // Método abstracto que debe ser implementado por clases derivadas
        public abstract string ObtenerCategoria();

        // Implementación de IReciclable
        public virtual string ObtenerTipoReciclaje()
        {
            return TipoMaterial;
        }

        public virtual bool EsReciclable()
        {
            return Activo;
        }

        public abstract decimal ObtenerImpactoAmbiental();
    }
}
