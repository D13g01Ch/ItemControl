<%-- 
    Document   : inicio
    Created on : 2 abr 2025, 5:40:49 p.m.
    Author     : Lluvia Alejandra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inicio de Sesión</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color:   #ffdaab;
        }

        .container {
            display: flex;
            height: 100vh;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .image-side {
            width: 50%;
            height: 100vh;
            background: url('LOGOTIPO.png') no-repeat center center/cover;
            border-bottom-right-radius: 50%;
            border-top-right-radius: 50%;
            animation: slideInLeft 1.5s ease-in-out;
        }

        .login-side {
            width: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeIn 1.5s ease-in-out;
        }

        .login-box {
            width: 80%;
            max-width: 400px;
            padding: 20px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            text-align: center;
            animation: slideIn 1s ease-out;
            background: transparent;
        }

        h2 {
            margin-bottom: 20px;
            color: #000026;
            animation: fadeIn 2s ease-in;
        }

        input {
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
            background: #005A9C;
            border: none;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            animation: fadeIn 2s ease-in;
        }

        button:hover {
            background: #0056b3;
        }

        .register-btn {
            background: #4CAF50;
        }

        .register-btn:hover {
            background: #218838;
        }

        .error {
            color: red;
            font-size: 14px;
            animation: fadeIn 2s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes slideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        @keyframes slideInLeft {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
    </style>
</head>
<body>
 <%-- Mostrar mensaje de éxito si viene del registro --%>
<% if ("true".equals(request.getParameter("registroExitoso"))) { %>
    <div class="alert alert-success" style="position: fixed; top: 20px; right: 20px; padding: 15px; background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 4px; z-index: 1000;">
        ¡Registro exitoso! Por favor inicie sesión
        <button type="button" style="margin-left: 15px; color: #155724; background: none; border: none; cursor: pointer;" onclick="this.parentElement.style.display='none'">×</button>
    </div>
    
    <script>
        // Ocultar automáticamente después de 5 segundos
        setTimeout(function() {
            var alert = document.querySelector('.alert.alert-success');
            if (alert) alert.style.display = 'none';
        }, 5000);
    </script>
<% } %>
    
<div class="container">
    <div class="image-side"></div>
    <div class="login-side">
        <div class="login-box">
           <h2>Iniciar Sesión</h2>
    <form id="loginForm" action="InicioServlet" method="POST">
        <input type="text" id="usuario" name="usuario" placeholder="Usuario" maxlength="15" required>
        <input type="password" id="password" name="password" placeholder="Contraseña" maxlength="10" required>
        <div class="button-container">
            <button type="submit">Ingresar</button>
            <button type="button" class="register-btn" onclick="window.location.href='registro.jsp'">Registrarse</button>
        </div>
        <p class="error" id="mensajeError"></p>
    </form>
        </div>
    </div>
</div>

<script>
    // Verificar si el usuario ya tiene una sesión activa y redirigir al dashboard
    if (localStorage.getItem("loggedIn") === "true") {
        window.location.href = "dashboard.jsp";
    }

    document.getElementById("usuario").addEventListener("keydown", function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            document.getElementById("password").focus();
        }
    });

    document.getElementById("password").addEventListener("keydown", function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            document.getElementById("loginForm").submit();
        }
    });

    document.getElementById("loginForm").addEventListener("submit", function(event) {
        var usuario = document.getElementById("usuario").value;
        var password = document.getElementById("password").value;
        var mensajeError = document.getElementById("mensajeError");
        
        if (usuario === "" || password === "") {
            event.preventDefault();
            mensajeError.textContent = "Por favor rellena todos los campos";
        }
    });
</script>

</body>
</html>