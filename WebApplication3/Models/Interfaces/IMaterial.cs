namespace WebApplication3.Models.Interfaces
{
    /// <summary>
    /// Interfaz para materiales reciclables
    /// </summary>
    public interface IMaterial : IEntidadBase
    {
        string Nombre { get; set; }
        string TipoMaterial { get; set; }
        decimal PuntosPorKilo { get; set; }
        string Descripcion { get; set; }
        decimal CalcularPuntos(decimal cantidad);
        string ObtenerCategoria();
    }
}
