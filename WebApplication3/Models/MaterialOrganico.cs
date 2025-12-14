using WebApplication3.Models.Base;

namespace WebApplication3.Models
{
    /// <summary>
    /// Material Orgánico - Herencia y polimorfismo
    /// </summary>
    public class MaterialOrganico : MaterialBase
    {
        public bool EsCompostable { get; set; }
        public int TiempoDescomposicion { get; set; } // En días

        public MaterialOrganico()
        {
            TipoMaterial = "Orgánico";
        }

        // Override - Polimorfismo: Materiales orgánicos dan 20% más de puntos
        public override decimal CalcularPuntos(decimal cantidad)
        {
            decimal puntosBase = base.CalcularPuntos(cantidad);
            return EsCompostable ? puntosBase * 1.2m : puntosBase;
        }

        // Implementación de método abstracto
        public override string ObtenerCategoria()
        {
            return "ORGÁNICO";
        }

        // Override - Polimorfismo
        public override decimal ObtenerImpactoAmbiental()
        {
            // Orgánicos tienen menor impacto (valor más bajo es mejor)
            return EsCompostable ? 0.5m : 1.0m;
        }

        public override string ObtenerTipoReciclaje()
        {
            return EsCompostable ? "Compostaje" : "Reciclaje Orgánico";
        }
    }
}
