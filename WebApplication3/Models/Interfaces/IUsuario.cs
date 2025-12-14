namespace WebApplication3.Models.Interfaces
{
    /// <summary>
    /// Interfaz para usuarios del sistema
    /// </summary>
    public interface IUsuario : IEntidadBase
    {
        string NombreCompleto { get; set; }
        string Email { get; set; }
        decimal PuntosAcumulados { get; set; }
        string ObtenerNivel();
        bool PuedeReclamarRecompensa(decimal puntosRequeridos);
    }
}
