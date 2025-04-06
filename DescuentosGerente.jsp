<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Gerente - Descuentos</title>
    <style>
        body {
            background: url('FONDO3.png') no-repeat center center/cover;
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
        }
        .logo {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
        }
        h2 {
            color: white;
            background-color: #007bff;
            padding: 10px;
            border-radius: 5px;
            display: inline-block;
        }
        .discount-management {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            color: white;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
        }
        .add-btn { background-color: #28a745; }
        .edit-btn { background-color: #17a2b8; }
        .delete-btn { background-color: #dc3545; }
        .discount-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .discount-table th, .discount-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .discount-table th {
            background-color: #007bff;
            color: white;
        }
        .discount-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .status-message {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .discount-form {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        .hidden {
            display: none;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.9em;
            margin-top: 5px;
            display: none;
        }
        .input-error {
            border-color: #dc3545 !important;
        }
        .status-active {
            color: #28a745;
            font-weight: bold;
        }
        .status-inactive {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="sidebar">  
        <h2>Menú</h2>    
        <a href="dashboardgerente.jsp">Inicio</a>
        <a href="UsuariosGerente.jsp">Administrar Usuarios</a>
        <a href="DescuentosGerente.jsp">Administrar Descuentos</a>
        <a href="login.jsp">Cerrar sesión</a>
    </div> 
    
    <div class="content">
        <img src="LOGOTIPO.png" alt="Logo" class="logo">
        
        <div class="discount-management">
            <h2>Gestión de Promociones</h2>
            
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
            
            <%-- Mensaje de error de validación del cliente --%>
            <div id="clientError" class="status-message error hidden"></div>
            
            <%-- Formulario de inserción/edición --%>
            <div id="discountForm" class="discount-form hidden">
                <h3 id="formTitle">Agregar Nueva Promoción</h3>
                <form action="DescuentosServlet" method="POST" onsubmit="return validarFormulario()">
                    <input type="hidden" name="action" id="formAction" value="insert">
                    <input type="hidden" name="idPromocion" id="idPromocion">
                    
                    <div class="form-group">
                        <label for="porcentaje">Porcentaje de Descuento:</label>
                        <input type="number" id="porcentaje" name="porcentaje" min="1" max="100" required>
                        <div id="porcentajeError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="descripcion">Descripción:</label>
                        <textarea id="descripcion" name="descripcion" rows="3" required></textarea>
                        <div id="descripcionError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaInicio">Fecha de Inicio:</label>
                        <input type="date" id="fechaInicio" name="fechaInicio" required>
                        <div id="fechaInicioError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="fechaFin">Fecha de Fin:</label>
                        <input type="date" id="fechaFin" name="fechaFin" required>
                        <div id="fechaFinError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="estado">Estado:</label>
                        <select id="estado" name="estado" required>
                            <option value="">Seleccione un estado</option>
                            <option value="vigente">Vigente</option>
                            <option value="expirada">Expirada</option>
                        </select>
                        <div id="estadoError" class="error-message"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="action-btn add-btn">Guardar</button>
                        <button type="button" onclick="hideDiscountForm()" class="action-btn delete-btn">Cancelar</button>
                    </div>
                </form>
            </div>
            
            <div class="action-buttons">
                <button onclick="showInsertForm()" class="action-btn add-btn">Agregar Nueva Promoción</button>
            </div>
            
            <%-- Tabla de promociones --%>
            <table class="discount-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>% Descuento</th>
                        <th>Descripción</th>
                        <th>Fecha Inicio</th>
                        <th>Fecha Fin</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
               <%
    Connection conn = null;
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(
            "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true",
            "Administrador", "Administrador");
        
        String sql = "SELECT id_Promocion, porcentaje_De_Descuento, descripcion, fecha_De_inicio, fecha_De_Fin, estado FROM promociones";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date today = new java.util.Date();
        
        while(rs.next()) {
            java.sql.Date fechaFinSQL = rs.getDate("fecha_De_Fin");
            java.util.Date fechaFin = null;
            if(fechaFinSQL != null) {
                fechaFin = new java.util.Date(fechaFinSQL.getTime());
            }
            
            String estadoClass = "status-active";
            if(rs.getString("estado").equals("expirada")) {
                estadoClass = "status-inactive";
            } else if(fechaFin != null && fechaFin.before(today)) {
                estadoClass = "status-inactive";
            }
%>
                    <tr>
                        <td><%= rs.getInt("id_Promocion") %></td>
                        <td><%= rs.getInt("porcentaje_De_Descuento") %>%</td>
                        <td><%= rs.getString("descripcion") %></td>
                        <td><%= rs.getDate("fecha_De_inicio") %></td>
                        <td><%= fechaFin %></td>
                        <td class="<%= estadoClass %>">
                            <%= rs.getString("estado") %>
                            <% if(fechaFin != null && fechaFin.before(today) && !rs.getString("estado").equals("expirada")) { %>
                                (Expirada)
                            <% } %>
                        </td>
                        <td>
                            <button onclick="showEditForm(
                                '<%= rs.getInt("id_Promocion") %>',
                                '<%= rs.getInt("porcentaje_De_Descuento") %>',
                                '<%= rs.getString("descripcion").replace("'", "\\'") %>',
                                '<%= rs.getDate("fecha_De_inicio") %>',
                                '<%= fechaFin %>',
                                '<%= rs.getString("estado") %>'
                            )" class="action-btn edit-btn" style="padding: 5px 10px; font-size: 0.9em;">
                                Editar
                            </button>
                            <a href="DescuentosServlet?action=delete&id=<%= rs.getInt("id_Promocion") %>" 
                               class="action-btn delete-btn" style="padding: 5px 10px; font-size: 0.9em;"
                               onclick="return confirm('¿Estás seguro de eliminar esta promoción?')">
                               Eliminar
                            </a>
                        </td>
                    </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } catch(Exception e) {
                        out.println("<div class='status-message error'>Error al cargar promociones: " + e.getMessage() + "</div>");
                    } finally {
                        if(conn != null) try { conn.close(); } catch(Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Mostrar formulario de inserción
        function showInsertForm() {
            document.getElementById('formTitle').textContent = 'Agregar Nueva Promoción';
            document.getElementById('formAction').value = 'insert';
            document.getElementById('idPromocion').value = '';
            
            // Fecha mínima (hoy)
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fechaInicio').min = today;
            document.getElementById('fechaFin').min = today;
            
            // Resetear valores
            document.getElementById('porcentaje').value = '';
            document.getElementById('descripcion').value = '';
            document.getElementById('fechaInicio').value = '';
            document.getElementById('fechaFin').value = '';
            document.getElementById('estado').value = 'vigente';
            
            resetErrors();
            document.getElementById('discountForm').classList.remove('hidden');
        }
        
        // Mostrar formulario de edición con datos precargados
        function showEditForm(id, porcentaje, descripcion, fechaInicio, fechaFin, estado) {
            document.getElementById('formTitle').textContent = 'Editar Promoción';
            document.getElementById('formAction').value = 'update';
            document.getElementById('idPromocion').value = id;
            document.getElementById('porcentaje').value = porcentaje;
            document.getElementById('descripcion').value = descripcion;
            document.getElementById('fechaInicio').value = fechaInicio;
            document.getElementById('fechaFin').value = fechaFin;
            document.getElementById('estado').value = estado;
            
            resetErrors();
            document.getElementById('discountForm').classList.remove('hidden');
        }
        
        // Ocultar formulario
        function hideDiscountForm() {
            document.getElementById('discountForm').classList.add('hidden');
        }
        
        // Validación del formulario
        function validarFormulario() {
            // Obtener elementos
            const porcentaje = document.getElementById("porcentaje");
            const descripcion = document.getElementById("descripcion");
            const fechaInicio = document.getElementById("fechaInicio");
            const fechaFin = document.getElementById("fechaFin");
            const estado = document.getElementById("estado");
            const errorElement = document.getElementById("clientError");
            
            // Limpiar errores anteriores
            errorElement.textContent = "";
            errorElement.classList.add("hidden");
            resetErrors();
            
            // Validar campos vacíos
            let camposVacios = 0;
            if (porcentaje.value.trim() === "") camposVacios++;
            if (descripcion.value.trim() === "") camposVacios++;
            if (fechaInicio.value.trim() === "") camposVacios++;
            if (fechaFin.value.trim() === "") camposVacios++;
            
            // 1. Validar cuando faltan múltiples campos
            if (camposVacios > 1) {
                showError("Por favor rellene todos los campos", errorElement);
                return false;
            }
            
            // 2. Validar campos individuales
            if (porcentaje.value.trim() === "") {
                showError("El porcentaje de descuento es obligatorio", document.getElementById("porcentajeError"), porcentaje);
                return false;
            }
            
            if (descripcion.value.trim() === "") {
                showError("La descripción es obligatoria", document.getElementById("descripcionError"), descripcion);
                return false;
            }
            
          
            if (fechaInicio.value.trim() === "") {
                showError("La fecha de inicio es obligatoria", document.getElementById("fechaInicioError"), fechaInicio);
                return false;
            }
            
            if (fechaFin.value.trim() === "") {
                showError("La fecha de fin es obligatoria", document.getElementById("fechaFinError"), fechaFin);
                return false;
            }
            
            // 3. Validar estado
            if (estado.value === "") {
                showError("Por favor seleccione un estado", document.getElementById("estadoError"), estado);
                return false;
            }
            
            // 4. Validar rango de porcentaje
            if (porcentaje.value < 1 || porcentaje.value > 100) {
                showError("El porcentaje debe estar entre 1 y 100", document.getElementById("porcentajeError"), porcentaje);
                return false;
            }
            
            // 5. Validar fechas
            const inicio = new Date(fechaInicio.value);
            const fin = new Date(fechaFin.value);
            
            if (fin < inicio) {
                showError("La fecha de fin no puede ser anterior a la fecha de inicio", document.getElementById("fechaFinError"), fechaFin);
                return false;
            }
            
            // 6. Validar longitud de descripción
            if (descripcion.value.length > 20) {
                showError("La descripción no puede exceder 20 caracteres", document.getElementById("descripcionError"), descripcion);
                return false;
            }
            
            return true;
        }
        
        // Mostrar error en un campo específico
        function showError(message, errorElement, inputElement = null) {
            errorElement.textContent = message;
            errorElement.style.display = "block";
            
            if (inputElement) {
                inputElement.classList.add("input-error");
            } else {
                // Es el error general
                const clientError = document.getElementById("clientError");
                clientError.textContent = message;
                clientError.classList.remove("hidden");
            }
        }
        
        // Resetear errores
        function resetErrors() {
            // Limpiar mensajes de error
            document.querySelectorAll(".error-message").forEach(el => {
                el.textContent = "";
                el.style.display = "none";
            });
            
            // Quitar clases de error de los inputs
            document.querySelectorAll(".input-error").forEach(el => {
                el.classList.remove("input-error");
            });
        }
        
        // Validación en tiempo real
        document.addEventListener("DOMContentLoaded", function() {
            const fields = ["porcentaje", "descripcion", "fechaInicio", "fechaFin", "estado"];
            
            fields.forEach(field => {
                const input = document.getElementById(field);
                if (input) {
                    input.addEventListener("input", function() {
                        // Limpiar solo el error de este campo
                        const errorElement = document.getElementById(field + "Error");
                        if (errorElement) {
                            errorElement.textContent = "";
                            errorElement.style.display = "none";
                        }
                        input.classList.remove("input-error");
                        
                        // También limpiar el error general si existe
                        document.getElementById("clientError").classList.add("hidden");
                    });
                }
            });
            
            // Validar fechas en tiempo real
            document.getElementById("fechaInicio").addEventListener("change", function() {
                const fechaInicio = this.value;
                if (fechaInicio) {
                    document.getElementById("fechaFin").min = fechaInicio;
                }
            });
        });
    </script>
</body>
</html>