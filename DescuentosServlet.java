package com.mycompany.is2.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "DescuentosServlet", urlPatterns = {"/DescuentosServlet"})
public class DescuentosServlet extends HttpServlet {
    
    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
    private static final String USER = "Administrador";
    private static final String PASS = "Administrador";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Manejar eliminación de promociones
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if("delete".equals(action) && idParam != null) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        int id = Integer.parseInt(idParam);
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(DB_URL, USER, PASS);
        
        String sql = "DELETE FROM promociones WHERE id_Promocion = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        int rowsAffected = pstmt.executeUpdate();
        
        if(rowsAffected > 0) {
            response.sendRedirect("DescuentosGerente.jsp?status=success&message=PROMOCION eliminada correctamente");
        } else {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=No se encontro la promocion a eliminar");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("DescuentosGerente.jsp?status=error&message=ID de promocion invalido");
    } catch (SQLException e) {
        // Verificar si es error de restricción de clave foránea
        if(e.getMessage().contains("REFERENCE constraint \"fk_Promo\"")) {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=Primero elimina los productos asociados a esta promocion");
        } else {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=Error al eliminar promocion: " + e.getMessage());
        }
    } catch (ClassNotFoundException e) {
        response.sendRedirect("DescuentosGerente.jsp?status=error&message=Error de conexión con la base de datos");
    } finally {
        try {
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
        }
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Manejar inserción y actualización de promociones
        String action = request.getParameter("action");
        String idParam = request.getParameter("idPromocion");
        String porcentajeParam = request.getParameter("porcentaje");
        String descripcion = request.getParameter("descripcion");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String estado = request.getParameter("estado");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            if("insert".equals(action)) {
                // Obtener el próximo ID disponible
                int nextId = 1;
                Statement stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT MAX(id_Promocion) AS max_id FROM promociones");
                if(rs.next()) {
                    nextId = rs.getInt("max_id") + 1;
                }
                
                // Insertar nueva promoción con el ID generado
                String sql = "INSERT INTO promociones (id_Promocion, porcentaje_De_Descuento, descripcion, fecha_De_inicio, fecha_De_Fin, estado) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, nextId);
                pstmt.setInt(2, Integer.parseInt(porcentajeParam));
                pstmt.setString(3, descripcion);
                pstmt.setDate(4, Date.valueOf(fechaInicio));
                pstmt.setDate(5, Date.valueOf(fechaFin));
                pstmt.setString(6, estado);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if(rowsAffected > 0) {
                    response.sendRedirect("DescuentosGerente.jsp?status=success&message=Promocion agregada correctamente con ID: " + nextId);
                } else {
                    response.sendRedirect("DescuentosGerente.jsp?status=error&message=Error al agregar promocion");
                }
                
                if(stmt != null) stmt.close();
            } else if("update".equals(action) && idParam != null) {
                // Actualizar promoción existente
                String sql = "UPDATE promociones SET porcentaje_De_Descuento = ?, descripcion = ?, fecha_De_inicio = ?, fecha_De_Fin = ?, estado = ? WHERE id_Promocion = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(porcentajeParam));
                pstmt.setString(2, descripcion);
                pstmt.setDate(3, Date.valueOf(fechaInicio));
                pstmt.setDate(4, Date.valueOf(fechaFin));
                pstmt.setString(5, estado);
                pstmt.setInt(6, Integer.parseInt(idParam));
                
                int rowsAffected = pstmt.executeUpdate();
                
                if(rowsAffected > 0) {
                    response.sendRedirect("DescuentosGerente.jsp?status=success&message=Promocion actualizada correctamente");
                } else {
                    response.sendRedirect("DescuentosGerente.jsp?status=error&message=Error al actualizar promocion");
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=Formato de numero invalido");
        } catch (IllegalArgumentException e) {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=Formato de fecha invalido");
        } catch (ClassNotFoundException | SQLException e) {
            response.sendRedirect("DescuentosGerente.jsp?status=error&message=Error en la operacion: " + e.getMessage());
        } finally {
            try {
                if(rs != null) rs.close();
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
    }
}