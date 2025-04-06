<%-- 
    Document   : UsuariosGerente
    Created on : 3 abr 2025, 7:50:39 p.m.
    Author     : Lluvia Alejandra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Gerente - Usuarios</title>
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
        .user-management {
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
        .user-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .user-table th, .user-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .user-table th {
            background-color: #007bff;
            color: white;
        }
        .user-table tr:nth-child(even) {
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
        .user-form {
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
        .form-group input, .form-group select {
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
        
        <div class="user-management">
            <h2>Gestión de Usuarios</h2>
            
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
            <div id="userForm" class="user-form hidden">
                <h3 id="formTitle">Agregar Nuevo Usuario</h3>
                <form action="UsuariosServlet" method="POST" onsubmit="return validarFormulario()">
                    <input type="hidden" name="action" id="formAction" value="insert">
                    <input type="hidden" name="oldUsername" id="oldUsername">
                    
                    <div class="form-group">
                        <label for="username">Nombre de Usuario:</label>
                        <input type="text" id="username" name="username" required>
                        <div id="usernameError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Contraseña:</label>
                        <input type="password" id="password" name="password" required>
                        <div id="passwordError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirmar Contraseña:</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <div id="confirmPasswordError" class="error-message"></div>
                    </div>
                    
                    <div class="form-group">
                        <label for="role">Rol:</label>
                        <select id="role" name="role" required>
                            <option value="">Seleccione un rol</option>
                            <option value="abarrotero">Abarrotero</option>
                            <option value="gerente">Gerente</option>
                        </select>
                        <div id="roleError" class="error-message"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="action-btn add-btn">Guardar</button>
                        <button type="button" onclick="hideUserForm()" class="action-btn delete-btn">Cancelar</button>
                    </div>
                </form>
            </div>
            
            <div class="action-buttons">
                <button onclick="showInsertForm()" class="action-btn add-btn">Agregar Nuevo Usuario</button>
            </div>
            
            <%-- Tabla de usuarios --%>
            <table class="user-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nombre de Usuario</th>
                        <th>Contraseña</th>
                        <th>Rol</th>
                        <th>Fecha de Alta</th>
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
                        
                        String sql = "SELECT id_Usuario, nombre_De_Usuario, contraseña, rol, fecha_De_Alta FROM usuarios";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        
                        while(rs.next()) {
                %>
                    <tr>
                        <td><%= rs.getInt("id_Usuario") %></td>
                        <td><%= rs.getString("nombre_De_Usuario") %></td>
                        <td><%= rs.getString("contraseña") %></td>
                        <td><%= rs.getString("rol") %></td>
                        <td><%= rs.getDate("fecha_De_Alta") %></td>
                        <td>
                            <button onclick="showEditForm(
                                '<%= rs.getString("nombre_De_Usuario") %>',
                                '<%= rs.getString("contraseña") %>',
                                '<%= rs.getString("rol") %>'
                            )" class="action-btn edit-btn" style="padding: 5px 10px; font-size: 0.9em;">
                                Editar
                            </button>
                            <a href="UsuariosServlet?action=delete&user=<%= rs.getString("nombre_De_Usuario") %>" 
                               class="action-btn delete-btn" style="padding: 5px 10px; font-size: 0.9em;"
                               onclick="return confirm('¿Estás seguro de eliminar este usuario?')">
                               Eliminar
                            </a>
                        </td>
                    </tr>
                <%
                        }
                        rs.close();
                        stmt.close();
                    } catch(Exception e) {
                        out.println("<div class='status-message error'>Error al cargar usuarios: " + e.getMessage() + "</div>");
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
            document.getElementById('formTitle').textContent = 'Agregar Nuevo Usuario';
            document.getElementById('formAction').value = 'insert';
            document.getElementById('oldUsername').value = '';
            document.getElementById('username').value = '';
            document.getElementById('password').value = '';
            document.getElementById('confirmPassword').value = '';
            document.getElementById('role').value = '';
            resetErrors();
            document.getElementById('userForm').classList.remove('hidden');
        }
        
        // Mostrar formulario de edición con datos precargados
        function showEditForm(username, password, role) {
            document.getElementById('formTitle').textContent = 'Editar Usuario';
            document.getElementById('formAction').value = 'update';
            document.getElementById('oldUsername').value = username;
            document.getElementById('username').value = username;
            document.getElementById('password').value = password;
            document.getElementById('confirmPassword').value = password;
            document.getElementById('role').value = role;
            resetErrors();
            document.getElementById('userForm').classList.remove('hidden');
        }
        
        // Ocultar formulario
        function hideUserForm() {
            document.getElementById('userForm').classList.add('hidden');
        }
        
        // Validación del formulario
        function validarFormulario() {
            // Obtener elementos
            const username = document.getElementById("username");
            const password = document.getElementById("password");
            const confirmPassword = document.getElementById("confirmPassword");
            const role = document.getElementById("role");
            const errorElement = document.getElementById("clientError");
            
            // Limpiar errores anteriores
            errorElement.textContent = "";
            errorElement.classList.add("hidden");
            resetErrors();
            
            // Validar campos vacíos
            let camposVacios = 0;
            if (username.value.trim() === "") camposVacios++;
            if (password.value.trim() === "") camposVacios++;
            if (confirmPassword.value.trim() === "") camposVacios++;
            
            // 1. Validar cuando faltan múltiples campos
            if (camposVacios > 1) {
                showError("Por favor rellene todos los campos", errorElement);
                return false;
            }
            
            // 2. Validar campos individuales
            if (username.value.trim() === "") {
                showError("El campo usuario es obligatorio", document.getElementById("usernameError"), username);
                return false;
            }
            
            if (password.value.trim() === "") {
                showError("El campo contraseña es obligatorio", document.getElementById("passwordError"), password);
                return false;
            }
            
            if (confirmPassword.value.trim() === "") {
                showError("Por favor confirme la contraseña", document.getElementById("confirmPasswordError"), confirmPassword);
                return false;
            }
            
            // 3. Validar rol
            if (role.value === "") {
                showError("Por favor seleccione un rol", document.getElementById("roleError"), role);
                return false;
            }
            
            // 4. Validar longitud de usuario
            if (username.value.length > 15) {
                showError("El usuario no puede exceder 15 caracteres", document.getElementById("usernameError"), username);
                return false;
            }
            
            // 5. Validar contraseña
            if (password.value.length < 6 || password.value.length > 10) {
                showError("La contraseña debe tener entre 6 y 10 caracteres", document.getElementById("passwordError"), password);
                return false;
            }
            
            if (password.value.includes(" ")) {
                showError("La contraseña no puede contener espacios", document.getElementById("passwordError"), password);
                return false;
            }
            
            // 6. Validar que las contraseñas coincidan
            if (password.value !== confirmPassword.value) {
                showError("Las contraseñas no coinciden", document.getElementById("confirmPasswordError"), confirmPassword);
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
            const fields = ["username", "password", "confirmPassword", "role"];
            
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
        });
    </script>
</body>
</html>