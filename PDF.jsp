<%-- 
    Document   : PDF
    Created on : 22 may 2025, 12:27:23 a.m.
    Author     : Lluvia Alejandra
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generar Reporte de Caducidad</title>
    <style>
        body {
            background: url('FONDO3new.png') no-repeat center center/cover;
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f4f4f4;
        }
        .sidebar {
            width: 250px;
            background: #007bff;
            padding: 20px;
            color: white;
            position: fixed;
            height: 100%;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            margin: 10px 0;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 5px;
        }
        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.4);
        }
        .content {
            margin-left: 270px;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Altura total de la ventana */
            box-sizing: border-box;

        }
        .logo {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            animation: spin 5s linear infinite;
        }
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        h1 {
            color: #007bff;
            text-align: center;
            background: white;
            padding: 10px;
            border-radius: 10px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="date"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .btn-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }

        .btn-primary {
            background-color: #28a745;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .status-message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
        }

        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>

    <div class="sidebar">  
        <h2>Menú</h2>    
        <a href="dashboardabarrotero.jsp">Inicio</a>
        <a href="dashboardabarrotero.jsp">Gestionar Invetario</a>
        <a href="PDF.jsp">Reporte de Caducidad</a>
        <a href="login.jsp">Cerrar sesión</a>
    </div> 

    <div class="content">
        <img src="LOGOTIPO.png" alt="Logo" class="logo">
    <div class="container">
        <h1>Generar Reporte de Caducidad</h1>
        
        <%-- Mostrar mensajes de éxito/error --%>
        <%
            String status = request.getParameter("status");
            String message = request.getParameter("message");
            if(status != null && message != null) {
        %>
        <div class="status-message <%= status %>">
            <%= message %>
        </div>
        <%
            }
        %>
        
        <div class="form-group">
            <label for="fechaReporte">Seleccione la fecha para el reporte:</label>
            <input type="date" id="fechaReporte" name="fechaReporte" required>
        </div>
        
        <div class="btn-container">
            <button class="btn btn-secondary" onclick="window.location.href='dashboardabarrotero.jsp'">Cancelar</button>
            <button class="btn btn-primary" id="btnGenerarPDF">Exportar PDF</button>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.28/jspdf.plugin.autotable.min.js"></script>

<script>
    
    document.addEventListener("DOMContentLoaded", function() {
        // Configurar fecha mínima y máxima (5 días antes hasta hoy)
        const fechaInput = document.getElementById("fechaReporte");
        const hoy = new Date();
        const fechaMin = new Date();
        fechaMin.setDate(hoy.getDate() - 5);

        // Formatear fechas para el input date (YYYY-MM-DD)
        const formatDateForInput = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };

        fechaInput.min = formatDateForInput(fechaMin);
        fechaInput.max = formatDateForInput(hoy);
        fechaInput.value = formatDateForInput(hoy); // Por defecto hoy
        // Manejar cambios manuales en el input para asegurarse que esté dentro del rango
        fechaInput.addEventListener('change', function() {
            const selectedDate = new Date(this.value);
            if (selectedDate < fechaMin || selectedDate > hoy) {
                alert("Por favor seleccione una fecha dentro del rango permitido (últimos 5 días)");
                this.value = formatDateForInput(hoy); // Resetear a hoy
            }
        });

        // Manejar clic en Generar PDF
        document.getElementById("btnGenerarPDF").addEventListener("click", generarReportePDF);
    });

    function formatDateForDisplay(date) {
    if (!date) return 'N/A';
    
    try {
        // Asegurarnos que es un objeto Date válido
        if (typeof date === 'string') {
            date = new Date(date);
        }
        
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        
        return `${day}/${month}/${year}`;
    } catch (e) {
        console.error('Error formateando fecha:', e);
        return 'Fecha inválida';
    }
}

    function generarReportePDF() {
        const fechaSeleccionada = document.getElementById("fechaReporte").value;
        if (!fechaSeleccionada) {
            alert("Por favor seleccione una fecha");
            return;
        }

        // Mostrar mensaje de carga
        const statusMessage = document.createElement('div');
        statusMessage.className = 'status-message';
        statusMessage.textContent = 'Generando reporte PDF...';
        document.querySelector('.container').prepend(statusMessage);

        const fechaReporte = new Date(fechaSeleccionada);
        const fechaInicio = new Date(fechaSeleccionada);
        fechaInicio.setDate(fechaInicio.getDate() - 5);

        fetch('ObtenerProductosServlet')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al obtener los datos');
                }
                return response.json();
            })
            .then(productos => {
                productos.forEach(p => {
                        p.fechaObj = new Date(p.fecha_De_Caducidad);
                    
                });
                  const hoy = new Date();
                  const proximosDias = 7;

                const caducados = productos.filter(p => p.fechaObj && p.fechaObj < hoy);
                const proximos = productos.filter(p => {
                     const limite = new Date(hoy);
                limite.setDate(limite.getDate() + proximosDias);
                return p.fechaObj >= hoy && p.fechaObj <= limite;
            });

                //GENERAR EL PDF
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF();
                // Formatear fecha para el reporte
                const fechaActual = formatDate(hoy);
                 // Encabezado del reporte
                doc.setFontSize(16);
                doc.text("Reporte de Productos por Caducidad", 105, 15, { align: 'center' });
                doc.setFontSize(10);
                doc.text("Reporte generado para el día: " + fechaActual, 105, 22, { align: 'center' });
                //PRODUCTOS CADUCADOS
                doc.setFontSize(12);
                doc.text("Productos Caducados", 14, 30);

                if (caducados.length > 0) {
                    doc.autoTable({
                        startY: 35,
                        head: [['Lote', 'Nombre', 'Precio', 'Stock', 'Caducidad', 'Proveedor']],
                        body: caducados.map(p => [
                            p.lote_Producto,
                            p.nombre_De_Producto,
                            '$' + p.precio_De_Venta.toFixed(2),
                            p.cantidad_En_Stock,
                            formatDate(new Date(p.fecha_De_Caducidad)),
                            p.proveedor || 'N/A'
                        ]),
                        headStyles: { fillColor: [220, 53, 69] },
                        bodyStyles: { fillColor: [255, 238, 240] },
                        margin: { top: 40 }
                    });
                } else {
                    doc.text("No hay productos caducados.", 14, 35);
                }

                let yProximos = doc.lastAutoTable ? doc.lastAutoTable.finalY + 15 : 50;
                //PRODUCTOS PROXIMOS A CADUCAR
                doc.setFontSize(12);
                doc.text("Productos Próximos a Caducar (en los próximos " + proximosDias + " días)", 14, yProximos);

                if (proximos.length > 0) {
                    doc.autoTable({
                        startY: yProximos + 5,
                        head: [['Lote', 'Nombre', 'Precio', 'Stock', 'Caducidad', 'Proveedor']],
                        body: proximos.map(p => [
                            p.lote_Producto,
                            p.nombre_De_Producto,
                            '$' + p.precio_De_Venta.toFixed(2),
                            p.cantidad_En_Stock,
                            formatDate(new Date(p.fecha_De_Caducidad)),
                            p.proveedor || 'N/A'
                        ]),
                        headStyles: { fillColor: [255, 193, 7] },
                        bodyStyles: { fillColor: [255, 248, 225] }
                    });
                } else {
                    doc.text("No hay productos próximos a caducar.", 14, yProximos + 5);
                }

                const totalPaginas = doc.internal.getNumberOfPages();
                for (let i = 1; i <= totalPaginas; i++) {
                    doc.setPage(i);
                    doc.setFontSize(8);
                    doc.text("Página " + i + " de " + totalPaginas, 105, 285, { align: 'center' });
                }
                //FORMATEAR NOMBRE DEL ARCHIVO
                const fechaArchivo = hoy.getFullYear() + "-" +
                    (hoy.getMonth() + 1).toString().padStart(2, '0') + "-" +
                    hoy.getDate().toString().padStart(2, '0');
                    //GUARDAR EL PDF
                doc.save(`Reporte_Caducidad_${fechaArchivo}.pdf`);

                statusMessage.textContent = 'Reporte generado con éxito!';
                statusMessage.className = 'status-message success';

                setTimeout(() => {
                    statusMessage.remove();
                }, 3000);
            })
            .catch(error => {
                console.error('Error:', error);
                statusMessage.textContent = 'Error al generar el reporte: ' + error.message;
                statusMessage.className = 'status-message error';
            });
    }
    // Función para formatear fechas
function formatDate(date) {
    if (!date) return 'N/A';
    return date.getDate() + "/" + 
           (date.getMonth() + 1) + "/" + 
           date.getFullYear();
}

function clearError(errorElement, inputElement) {
    errorElement.textContent = "";
    errorElement.style.display = "none";
    inputElement.classList.remove("input-error");
}

</script>

</body>
    </html>