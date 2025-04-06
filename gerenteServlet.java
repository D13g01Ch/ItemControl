/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.is2.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "gerenteServlet", urlPatterns = {"/gerenteServlet"})
public class gerenteServlet extends HttpServlet {
    
    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
    private static final String USER = "Administrador";
    private static final String PASS = "Administrador";

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(JDBC_DRIVER);
        return DriverManager.getConnection(DB_URL, USER, PASS);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            if ("add".equals(action)) {
                String sql = "INSERT INTO usuarios (nombre_De_Usuario, contraseña, rol, fecha_De_Alta) VALUES (?, ?, ?, GETDATE())";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, role);
                
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("dashboardgerente.jsp?section=users&success=add");
                } else {
                    response.sendRedirect("dashboardgerente.jsp?section=users&error=Error al agregar usuario");
                }
                
            } else if ("update".equals(action)) {
                String id = request.getParameter("id");
                String sql = "UPDATE usuarios SET nombre_De_Usuario = ?, contraseña = ?, rol = ? WHERE id_Usuario = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, role);
                pstmt.setInt(4, Integer.parseInt(id));
                
                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    response.sendRedirect("dashboardgerente.jsp?section=users&success=update");
                } else {
                    response.sendRedirect("dashboardgerente.jsp?section=users&error=Error al actualizar usuario");
                }
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("dashboardgerente.jsp?section=users&error=Error de conexión con la base de datos: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}