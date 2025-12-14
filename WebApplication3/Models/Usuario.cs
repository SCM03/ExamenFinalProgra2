using System;
using WebApplication3.Models.Base;
using WebApplication3.Models.Interfaces;

namespace WebApplication3.Models
{
    /// <summary>
    /// Modelo de Usuario con herencia de EntidadBase e implementación de IUsuario
    /// </summary>
    public class Usuario : EntidadBase, IUsuario
    {
        public string NombreCompleto { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public decimal PuntosAcumulados { get; set; }
        public int TotalReciclajesRealizados { get; set; }
        public decimal TotalKilosReciclados { get; set; }

        public Usuario()
        {
            PuntosAcumulados = 0;
            TotalReciclajesRealizados = 0;
            TotalKilosReciclados = 0;
        }

        // Implementación de método de interfaz con lógica de negocio
        public string ObtenerNivel()
        {
            if (PuntosAcumulados >= 10000)
                return "Diamante";
            else if (PuntosAcumulados >= 5000)
                return "Oro";
            else if (PuntosAcumulados >= 2000)
                return "Plata";
            else if (PuntosAcumulados >= 500)
                return "Bronce";
            else
                return "Principiante";
        }

        public bool PuedeReclamarRecompensa(decimal puntosRequeridos)
        {
            return PuntosAcumulados >= puntosRequeridos && Activo;
        }

        public void AgregarPuntos(decimal puntos, decimal kilos)
        {
            PuntosAcumulados += puntos;
            TotalReciclajesRealizados++;
            TotalKilosReciclados += kilos;
            Actualizar();
        }

        public bool DescontarPuntos(decimal puntos)
        {
            if (PuntosAcumulados >= puntos)
            {
                PuntosAcumulados -= puntos;
                Actualizar();
                return true;
            }
            return false;
        }
    }
}
