namespace WebApplication3.Models.Interfaces
{
    /// <summary>
    /// Interfaz para objetos reciclables con comportamiento común
    /// </summary>
    public interface IReciclable
    {
        string ObtenerTipoReciclaje();
        bool EsReciclable();
        decimal ObtenerImpactoAmbiental();
    }
}
