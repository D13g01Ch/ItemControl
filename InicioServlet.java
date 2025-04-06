package com.mycompany.is2.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.PrintWriter;

@WebServlet(name = "InicioServlet", urlPatterns = {"/InicioServlet"})
public class InicioServlet extends HttpServlet {
    
    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
    private static final String USER = "Administrador";
    private static final String PASS = "Administrador";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            String sql = "SELECT nombre_De_Usuario, contraseña, rol FROM usuarios WHERE nombre_De_Usuario = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usuario);
            
            rs = pstmt.executeQuery();
            
             if (rs.next()) {
                String storedPassword = rs.getString("contraseña");
                String rol = rs.getString("rol");
                
                if (password.equals(storedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("usuario", usuario);
                    session.setAttribute("rol", rol);
                    
                    // Redirigir según el rol
                    if ("gerente".equalsIgnoreCase(rol)) {
                        response.sendRedirect("dashboardgerente.jsp");
                    } else {
                        //Aqui seria dasboardAbarrotero
                        response.sendRedirect("dashboardabarrotero.jsp");
                    }
                } else {
                    out.println("<script>alert('Contraseña incorrecta'); window.location.href='login.jsp';</script>");
                }
            } else {
                out.println("<script>alert('Usuario no encontrado'); window.location.href='login.jsp';</script>");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Error de conexión con la base de datos'); window.location.href='login.jsp';</script>");
        } finally {
            // ... (el resto del código permanece igual)
        }
    }
}
