<%-- 
    Document   : registro
    Created on : 2 abr 2025, 5:37:58 p.m.
    Author     : Lluvia Alejandra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: url('REGISTRO.png') no-repeat center center/cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }

        .top-border, .bottom-border {
            width: 100%;
            height: 60px;
            background-color: #fe5575;
            position: absolute;
            left: 0;
        }

        .top-border {
            top: 0;
        }

        .bottom-border {
            bottom: 0;
        }

        .form-side {
            width: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeIn 1.5s ease-in-out;
            background: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 10px;
            z-index: 1;
        }

        .form-box {
            width: 80%;
            max-width: 400px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            text-align: center;
            animation: slideIn 1s ease-out;
            background: white;
        }

        h2 {
            margin-bottom: 20px;
            color: #333;
            animation: fadeIn 2s ease-in;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            background: white;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        button {
            width: 100%;
            padding: 10px;
            background: #28a745;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            animation: fadeIn 2s ease-in;
        }

        button:hover {
            background: #218838;
        }

        .error-messages {
        min-height: 40px;
        margin-bottom: 10px;
        }

        .error {
         color: #dc3545;
         font-size: 14px;
         margin: 5px 0;
        animation: fadeIn 0.3s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>

<div class="top-border"></div>

<div class="top-border"></div>

<div class="form-side">
    <div class="form-box">
        <h2>Registro de Usuario</h2>
        <!-- Mostrar mensaje de error si existe -->
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
        
        <form id="registroForm" action="RegistroServlet" method="POST" onsubmit="return validarFormulario()">
    <!-- Mantener valor del usuario si hubo error -->
    <input type="text" id="usuario" name="usuario" placeholder="Usuario" 
           value="<%= request.getAttribute("usuarioValue") != null ? request.getAttribute("usuarioValue") : "" %>"
           maxlength="15">
    
    <input type="password" id="password" name="password" placeholder="Contraseña " maxlength="10">
    
    <input type="password" id="adminPassword" name="adminPassword" placeholder="Contraseña del Administrador" maxlength="10">
    
    <!-- Mantener selección de rol si hubo error -->
  <select id="rol" name="rol">
    <option value="" disabled selected>Seleccione un rol</option>
    <option value="abarrotero" <%= "abarrotero".equals(request.getAttribute("rolValue")) ? "selected" : "" %>>Abarrotero</option>
    <option value="gerente" <%= "gerente".equals(request.getAttribute("rolValue")) ? "selected" : "" %>>Gerente</option>
</select>
    <div class="button-container">
        <button type="submit">Registrar</button>
        <button type="button" onclick="window.location.href='login.jsp'">Volver</button>
    </div>
    
    <div class="error-messages">
        <% if (request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
        <p class="error" id="clientError"></p>
    </div>
</form>
    </div>
</div>

<div class="bottom-border"></div>

<script>
function validarFormulario() {
    // Obtener elementos
    const usuario = document.getElementById("usuario");
    const password = document.getElementById("password");
    const adminPassword = document.getElementById("adminPassword");
    const rol = document.getElementById("rol");
    const errorElement = document.getElementById("clientError");
    
    // Limpiar errores anteriores
    errorElement.textContent = "";
    
    // Contar campos vacíos (excepto rol)
    let camposVacios = 0;
    if (usuario.value.trim() === "") camposVacios++;
    if (password.value.trim() === "") camposVacios++;
    if (adminPassword.value.trim() === "") camposVacios++;
    
    // 1. Validar cuando faltan múltiples campos (excepto rol)
    if (camposVacios > 1) {
        errorElement.textContent = "Por favor rellene todos los campos";
        return false;
    }
    
    // 2. Validar campos individuales (excepto rol)
    if (usuario.value.trim() === "") {
        errorElement.textContent = "El campo usuario es obligatorio";
        return false;
    }
    
    if (password.value.trim() === "") {
        errorElement.textContent = "El campo contraseña es obligatorio";
        return false;
    }
    
    if (adminPassword.value.trim() === "") {
        errorElement.textContent = "La contraseña de administrador es obligatoria";
        return false;
    }
    
    // 3. Solo si los otros campos están llenos, validar rol
    if (rol.value === "") {
        errorElement.textContent = "Por favor seleccione un rol";
        return false;
    }
    
    // 4. Validar longitud de usuario
    if (usuario.value.length > 15) {
        errorElement.textContent = "El usuario no puede exceder 15 caracteres";
        return false;
    }
    
    // 5. Validar contraseña
    if (password.value.length < 6 || password.value.length > 10) {
        errorElement.textContent = "La contraseña debe tener entre 6 y 10 caracteres";
        return false;
    }
    
    if (password.value.includes(" ")) {
        errorElement.textContent = "La contraseña no puede contener espacios";
        return false;
    }
    
    // Si todo es válido
    return true;
}

// Validación en tiempo real
document.addEventListener("DOMContentLoaded", function() {
    const fields = ["usuario", "password", "adminPassword", "rol"];
    
    fields.forEach(field => {
        document.getElementById(field).addEventListener("input", function() {
            document.getElementById("clientError").textContent = "";
        });
    });
});
</script>
</body>
</html> 