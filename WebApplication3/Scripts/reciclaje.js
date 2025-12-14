// ====================================================================
// SISTEMA DE GESTIÓN DE RECICLAJE - JAVASCRIPT
// ====================================================================

// ====================================================================
// VALIDACIONES DE FORMULARIOS
// ====================================================================

/**
 * Valida un formulario de registro de reciclaje
 */
function validarFormularioReciclaje() {
    const tipoMaterial = document.getElementById('ddlTipoMaterial');
    const material = document.getElementById('ddlMaterial');
    const cantidad = document.getElementById('txtCantidad');
    
    let errores = [];
    
    if (!tipoMaterial || tipoMaterial.value === '') {
        errores.push('Debe seleccionar un tipo de material');
    }
    
    if (!material || material.value === '') {
        errores.push('Debe seleccionar un material específico');
    }
    
    if (!cantidad || cantidad.value === '' || parseFloat(cantidad.value) <= 0) {
        errores.push('La cantidad debe ser mayor a 0');
    }
    
    if (errores.length > 0) {
        mostrarAlerta(errores.join('<br>'), 'danger');
        return false;
    }
    
    return true;
}

/**
 * Valida un formulario de registro de usuario
 */
function validarFormularioRegistro() {
    const nombre = document.getElementById('txtNombre');
    const email = document.getElementById('txtEmail');
    const password = document.getElementById('txtPassword');
    
    let errores = [];
    
    if (!nombre || nombre.value.trim().length < 3) {
        errores.push('El nombre debe tener al menos 3 caracteres');
    }
    
    if (!email || !validarEmail(email.value)) {
        errores.push('Ingrese un email válido');
    }
    
    if (!password || password.value.length < 6) {
        errores.push('La contraseña debe tener al menos 6 caracteres');
    }
    
    if (errores.length > 0) {
        mostrarAlerta(errores.join('<br>'), 'danger');
        return false;
    }
    
    return true;
}

/**
 * Valida formato de email
 */
function validarEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

// ====================================================================
// CÁLCULO DE PUNTOS EN TIEMPO REAL
// ====================================================================

/**
 * Calcula y muestra puntos basados en material y cantidad
 */
function calcularPuntosReciclaje() {
    const materialSelect = document.getElementById('ddlMaterial');
    const cantidadInput = document.getElementById('txtCantidad');
    const puntosLabel = document.getElementById('lblPuntosCalculados');
    const puntosPanel = document.getElementById('pnlCalculoPuntos');
    
    if (!materialSelect || !cantidadInput || !puntosLabel || !puntosPanel) {
        return;
    }
    
    const puntosPorKilo = parseFloat(materialSelect.getAttribute('data-puntos') || 0);
    const cantidad = parseFloat(cantidadInput.value || 0);
    
    if (puntosPorKilo > 0 && cantidad > 0) {
        const puntosTotal = puntosPorKilo * cantidad;
        puntosLabel.textContent = puntosTotal.toFixed(0);
        puntosPanel.style.display = 'block';
        
        // Animación de puntos
        animarNumero(puntosLabel, 0, puntosTotal, 500);
    } else {
        puntosPanel.style.display = 'none';
    }
}

/**
 * Anima un número desde un valor inicial a uno final
 */
function animarNumero(elemento, inicio, fin, duracion) {
    const rango = fin - inicio;
    const incremento = rango / (duracion / 16);
    let actual = inicio;
    
    const timer = setInterval(() => {
        actual += incremento;
        if ((incremento > 0 && actual >= fin) || (incremento < 0 && actual <= fin)) {
            actual = fin;
            clearInterval(timer);
        }
        elemento.textContent = Math.floor(actual).toLocaleString('es-CL');
    }, 16);
}

// ====================================================================
// CONFIRMACIONES
// ====================================================================

/**
 * Confirma el canje de una recompensa
 */
function confirmarCanje(nombreRecompensa, puntosRequeridos, puntosDisponibles) {
    if (puntosDisponibles < puntosRequeridos) {
        mostrarAlerta(`No tienes suficientes puntos. Necesitas ${puntosRequeridos} puntos.`, 'warning');
        return false;
    }
    
    return confirm(`¿Estás seguro de canjear "${nombreRecompensa}" por ${puntosRequeridos} puntos?`);
}

/**
 * Confirma eliminación o acción destructiva
 */
function confirmarAccion(mensaje) {
    return confirm(mensaje || '¿Estás seguro de realizar esta acción?');
}

// ====================================================================
// ALERTAS Y NOTIFICACIONES
// ====================================================================

/**
 * Muestra una alerta personalizada
 */
function mostrarAlerta(mensaje, tipo = 'info') {
    const alertaDiv = document.createElement('div');
    alertaDiv.className = `alert alert-${tipo}`;
    alertaDiv.innerHTML = `
        <i class="fas fa-${obtenerIconoAlerta(tipo)}"></i>
        ${mensaje}
        <button type="button" class="close" onclick="this.parentElement.remove()">
            <span>&times;</span>
        </button>
    `;
    
    // Insertar al inicio del contenedor principal
    const container = document.querySelector('.container') || document.body;
    container.insertBefore(alertaDiv, container.firstChild);
    
    // Auto-remover después de 5 segundos
    setTimeout(() => {
        if (alertaDiv.parentElement) {
            alertaDiv.remove();
        }
    }, 5000);
}

/**
 * Obtiene el icono apropiado para el tipo de alerta
 */
function obtenerIconoAlerta(tipo) {
    const iconos = {
        'success': 'check-circle',
        'danger': 'exclamation-circle',
        'warning': 'exclamation-triangle',
        'info': 'info-circle'
    };
    return iconos[tipo] || 'info-circle';
}

/**
 * Muestra notificación toast (pequeña notificación en esquina)
 */
function mostrarToast(mensaje, tipo = 'info') {
    // Crear contenedor de toasts si no existe
    let toastContainer = document.getElementById('toast-container');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
        document.body.appendChild(toastContainer);
    }
    
    const toast = document.createElement('div');
    toast.className = `alert alert-${tipo}`;
    toast.style.cssText = 'margin-bottom: 10px; min-width: 250px; box-shadow: 0 4px 6px rgba(0,0,0,0.2);';
    toast.innerHTML = `
        <i class="fas fa-${obtenerIconoAlerta(tipo)}"></i>
        ${mensaje}
    `;
    
    toastContainer.appendChild(toast);
    
    // Auto-remover después de 3 segundos
    setTimeout(() => {
        toast.style.transition = 'opacity 0.5s';
        toast.style.opacity = '0';
        setTimeout(() => toast.remove(), 500);
    }, 3000);
}

// ====================================================================
// FORMATEO Y UTILIDADES
// ====================================================================

/**
 * Formatea un número con separadores de miles
 */
function formatearNumero(numero, decimales = 0) {
    return parseFloat(numero).toLocaleString('es-CL', {
        minimumFractionDigits: decimales,
        maximumFractionDigits: decimales
    });
}

/**
 * Formatea una fecha
 */
function formatearFecha(fecha, incluirHora = false) {
    const f = new Date(fecha);
    const opciones = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    };
    
    if (incluirHora) {
        opciones.hour = '2-digit';
        opciones.minute = '2-digit';
    }
    
    return f.toLocaleString('es-CL', opciones);
}

/**
 * Calcula CO2 evitado (aproximado)
 */
function calcularCO2Evitado(kilos) {
    return kilos * 2; // Aproximación: 1 kg reciclado = 2 kg CO2 evitado
}

// ====================================================================
// ANIMACIONES Y EFECTOS VISUALES
// ====================================================================

/**
 * Anima elementos al hacer scroll
 */
function animarAlScroll() {
    const elementos = document.querySelectorAll('.stat-card, .action-card, .recompensa-card');
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '0';
                entry.target.style.transform = 'translateY(20px)';
                entry.target.style.transition = 'opacity 0.5s, transform 0.5s';
                
                setTimeout(() => {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }, 100);
                
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });
    
    elementos.forEach(el => observer.observe(el));
}

/**
 * Efecto de contador animado
 */
function animarContadores() {
    const contadores = document.querySelectorAll('.stat-card h3, .stat-box h3');
    
    contadores.forEach(contador => {
        const textoOriginal = contador.textContent;
        const numero = parseFloat(textoOriginal.replace(/[^\d.-]/g, ''));
        
        if (!isNaN(numero)) {
            contador.textContent = '0';
            animarNumero(contador, 0, numero, 1000);
        }
    });
}

// ====================================================================
// FILTROS Y BÚSQUEDA
// ====================================================================

/**
 * Filtra elementos de una tabla
 */
function filtrarTabla(inputId, tablaId) {
    const input = document.getElementById(inputId);
    const tabla = document.getElementById(tablaId);
    
    if (!input || !tabla) return;
    
    const filtro = input.value.toUpperCase();
    const filas = tabla.getElementsByTagName('tr');
    
    for (let i = 1; i < filas.length; i++) {
        const fila = filas[i];
        const celdas = fila.getElementsByTagName('td');
        let mostrar = false;
        
        for (let j = 0; j < celdas.length; j++) {
            const celda = celdas[j];
            if (celda.textContent.toUpperCase().indexOf(filtro) > -1) {
                mostrar = true;
                break;
            }
        }
        
        fila.style.display = mostrar ? '' : 'none';
    }
}

/**
 * Ordena una tabla por columna
 */
function ordenarTabla(tablaId, columna, ascendente = true) {
    const tabla = document.getElementById(tablaId);
    if (!tabla) return;
    
    const tbody = tabla.tBodies[0];
    const filas = Array.from(tbody.rows);
    
    filas.sort((a, b) => {
        const valorA = a.cells[columna].textContent.trim();
        const valorB = b.cells[columna].textContent.trim();
        
        // Intentar convertir a número
        const numA = parseFloat(valorA.replace(/[^\d.-]/g, ''));
        const numB = parseFloat(valorB.replace(/[^\d.-]/g, ''));
        
        if (!isNaN(numA) && !isNaN(numB)) {
            return ascendente ? numA - numB : numB - numA;
        }
        
        return ascendente 
            ? valorA.localeCompare(valorB)
            : valorB.localeCompare(valorA);
    });
    
    filas.forEach(fila => tbody.appendChild(fila));
}

// ====================================================================
// GRÁFICOS (Helper functions para Chart.js)
// ====================================================================

/**
 * Configuración predeterminada para gráficos de barras
 */
function obtenerConfigBarras(labels, data, titulo) {
    return {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: titulo,
                data: data,
                backgroundColor: [
                    'rgba(76, 175, 80, 0.6)',
                    'rgba(33, 150, 243, 0.6)',
                    'rgba(255, 152, 0, 0.6)',
                    'rgba(156, 39, 176, 0.6)',
                    'rgba(233, 30, 99, 0.6)'
                ],
                borderColor: [
                    'rgba(76, 175, 80, 1)',
                    'rgba(33, 150, 243, 1)',
                    'rgba(255, 152, 0, 1)',
                    'rgba(156, 39, 176, 1)',
                    'rgba(233, 30, 99, 1)'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    };
}

/**
 * Configuración predeterminada para gráficos de pastel
 */
function obtenerConfigPastel(labels, data) {
    return {
        type: 'doughnut',
        data: {
            labels: labels,
            datasets: [{
                data: data,
                backgroundColor: [
                    'rgba(76, 175, 80, 0.8)',
                    'rgba(33, 150, 243, 0.8)',
                    'rgba(255, 152, 0, 0.8)',
                    'rgba(156, 39, 176, 0.8)'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    };
}

// ====================================================================
// EXPORT DE DATOS
// ====================================================================

/**
 * Exporta una tabla a CSV
 */
function exportarTablaCSV(tablaId, nombreArchivo = 'datos.csv') {
    const tabla = document.getElementById(tablaId);
    if (!tabla) return;
    
    let csv = [];
    const filas = tabla.rows;
    
    for (let i = 0; i < filas.length; i++) {
        const fila = [];
        const celdas = filas[i].cells;
        
        for (let j = 0; j < celdas.length; j++) {
            fila.push(celdas[j].textContent);
        }
        
        csv.push(fila.join(','));
    }
    
    const csvString = csv.join('\n');
    const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    
    if (link.download !== undefined) {
        const url = URL.createObjectURL(blob);
        link.setAttribute('href', url);
        link.setAttribute('download', nombreArchivo);
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

// ====================================================================
// INICIALIZACIÓN
// ====================================================================

/**
 * Inicializa funciones cuando el DOM está listo
 */
document.addEventListener('DOMContentLoaded', function() {
    // Animar elementos al cargar
    setTimeout(animarAlScroll, 100);
    
    // Animar contadores si existen
    if (document.querySelector('.stat-card h3')) {
        setTimeout(animarContadores, 200);
    }
    
    // Event listeners para cálculo de puntos en tiempo real
    const cantidadInput = document.getElementById('txtCantidad');
    if (cantidadInput) {
        cantidadInput.addEventListener('input', calcularPuntosReciclaje);
    }
    
    console.log('Sistema de Reciclaje - JavaScript inicializado correctamente');
});

// ====================================================================
// EXPORTS PARA USO GLOBAL
// ====================================================================

window.ReciclajeJS = {
    validarFormularioReciclaje,
    validarFormularioRegistro,
    validarEmail,
    calcularPuntosReciclaje,
    confirmarCanje,
    confirmarAccion,
    mostrarAlerta,
    mostrarToast,
    formatearNumero,
    formatearFecha,
    calcularCO2Evitado,
    filtrarTabla,
    ordenarTabla,
    exportarTablaCSV
};

console.log('ReciclajeJS cargado - Versión 1.0');
