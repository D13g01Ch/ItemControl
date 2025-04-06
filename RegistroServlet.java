package com.mycompany.is2.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.time.Instant;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {
    
    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
    private static final String USER = "Administrador";
    private static final String PASS = "Administrador";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombreDeUsuario = request.getParameter("usuario");
        String contraseña = request.getParameter("password");
        String adminPassword = request.getParameter("adminPassword");
        String rol = request.getParameter("rol");
        // Validar campos vacíos en el servidor
        if (nombreDeUsuario == null || nombreDeUsuario.isEmpty() || 
        contraseña == null || contraseña.isEmpty() ||
        adminPassword == null || adminPassword.isEmpty() ||
        rol == null || rol.isEmpty()) {
        
        request.setAttribute("errorMessage", "Todos los campos son obligatorios");
        request.getRequestDispatcher("registro.jsp").forward(request, response);
        return;
    }


        // Verificar contraseña de administrador
        if (!"admin123".equals(adminPassword)) {
            request.setAttribute("errorMessage", "Contraseña de administrador incorrecta");
            forwardToRegister(request, response);
            return;
        }

        // Validar rol
        if (!"abarrotero".equals(rol) && !"gerente".equals(rol)) {
            request.setAttribute("errorMessage", "Debe seleccionar un rol válido");
            forwardToRegister(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            // Verificar si el usuario ya existe
            String checkUserSql = "SELECT nombre_De_Usuario FROM usuarios WHERE nombre_De_Usuario = ?";
            pstmt = conn.prepareStatement(checkUserSql);
            pstmt.setString(1, nombreDeUsuario);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("errorMessage", "El nombre de usuario ya está en uso. Por favor elija otro.");
                request.setAttribute("usuarioValue", nombreDeUsuario); // Mantener el valor ingresado
                request.setAttribute("rolValue", rol); // Mantener el rol seleccionado
                forwardToRegister(request, response);
                return;
            }
            
            rs.close();
            pstmt.close();
            
            // Registrar nuevo usuario
            String insertSql = "INSERT INTO usuarios (nombre_De_Usuario, contraseña, fecha_De_Alta, rol) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            
            pstmt.setString(1, nombreDeUsuario);
            pstmt.setString(2, contraseña);
            pstmt.setTimestamp(3, Timestamp.from(Instant.now()));
            pstmt.setString(4, rol);
            
            int rows = pstmt.executeUpdate();
            
           if (rows > 0) {
    // Registro exitoso - redirigir a login.jsp con parámetro
    response.sendRedirect("login.jsp?registroExitoso=true");
} else {
    request.setAttribute("errorMessage", "Error al registrar usuario");
    forwardToRegister(request, response);
}
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error de conexión con la base de datos");
            forwardToRegister(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    private void forwardToRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("registro.jsp");
        dispatcher.forward(request, response);
    }
}