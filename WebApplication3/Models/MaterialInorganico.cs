using WebApplication3.Models.Base;

namespace WebApplication3.Models
{
    /// <summary>
    /// Material Inorgánico - Herencia y polimorfismo
    /// </summary>
    public class MaterialInorganico : MaterialBase
    {
        public string SubCategoria { get; set; } // Plástico, Vidrio, Metal, Papel
        public bool RequiereLimpiezaPrevia { get; set; }
        public int TiempoDescomposicionNatural { get; set; } // En años

        public MaterialInorganico()
        {
            TipoMaterial = "Inorgánico";
        }

        // Override - Polimorfismo: Materiales que requieren limpieza dan menos puntos
        public override decimal CalcularPuntos(decimal cantidad)
        {
            decimal puntosBase = base.CalcularPuntos(cantidad);
            
            // Bonificación por subcategoría
            decimal multiplicador = 1.0m;
            switch (SubCategoria?.ToUpper())
            {
                case "VIDRIO":
                    multiplicador = 1.3m;
                    break;
                case "METAL":
                    multiplicador = 1.5m;
                    break;
                case "PAPEL":
                    multiplicador = 1.1m;
                    break;
                case "PLÁSTICO":
                    multiplicador = 1.0m;
                    break;
            }

            return RequiereLimpiezaPrevia ? puntosBase * multiplicador * 0.9m : puntosBase * multiplicador;
        }

        // Implementación de método abstracto
        public override string ObtenerCategoria()
        {
            return $"INORGÁNICO - {SubCategoria?.ToUpper() ?? "GENERAL"}";
        }

        // Override - Polimorfismo
        public override decimal ObtenerImpactoAmbiental()
        {
            // Inorgánicos tienen mayor impacto basado en tiempo de descomposición
            if (TiempoDescomposicionNatural > 1000)
                return 10.0m; // Muy alto impacto (plásticos)
            else if (TiempoDescomposicionNatural > 100)
                return 7.0m; // Alto impacto
            else if (TiempoDescomposicionNatural > 10)
                return 4.0m; // Medio impacto
            else
                return 2.0m; // Bajo impacto
        }

        public override string ObtenerTipoReciclaje()
        {
            return $"Reciclaje de {SubCategoria}";
        }
    }
}
