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

@WebServlet(name = "ProductosServlet", urlPatterns = {"/ProductosServlet"})
public class ProductosServlet extends HttpServlet {
    
    private static final String JDBC_DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
    private static final String USER = "Administrador";
    private static final String PASS = "Administrador";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Manejar eliminación de productos
        String action = request.getParameter("action");
        String loteParam = request.getParameter("loteProducto");
        
        if("delete".equals(action) && loteParam != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            
            try {
                long lote = Long.parseLong(loteParam);
                Class.forName(JDBC_DRIVER);
                conn = DriverManager.getConnection(DB_URL, USER, PASS);
                
                String sql = "DELETE FROM Productos WHERE lote_Producto = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setLong(1, lote);
                int rowsAffected = pstmt.executeUpdate();
                
                if(rowsAffected > 0) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=success&message=Producto eliminado correctamente");
                } else {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=No se encontró el producto a eliminar");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Número de lote inválido");
            } catch (SQLException e) {
                if(e.getMessage().contains("REFERENCE constraint")) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=No se puede eliminar, el producto está asociado a otras tablas");
                } else {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Error al eliminar producto: " + e.getMessage());
                }
            } catch (ClassNotFoundException e) {
                response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Error de conexión con la base de datos");
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
        // Manejar inserción y actualización de productos
        String action = request.getParameter("action");
        String loteParam = request.getParameter("loteProducto");
        
        // Obtener todos los parámetros del formulario
        String nombre = request.getParameter("nombre");
        String idPromocionParam = request.getParameter("idPromocion");
        String fechaCaducidad = request.getParameter("fechaCaducidad");
        String proveedor = request.getParameter("proveedor");
        String precioParam = request.getParameter("precio");
        String stockParam = request.getParameter("stock");
        String departamento = request.getParameter("departamento");
        String marca = request.getParameter("marca");
        String fechaIngreso = request.getParameter("fechaIngreso");
        String codigoBarras = request.getParameter("codigoBarras");
        String estado = request.getParameter("estado");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            if("insert".equals(action)) {
                // Validar que se proporcionó el lote
                if(loteParam == null || loteParam.isEmpty()) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=El número de lote es requerido");
                    return;
                }
                
                // Verificar si el lote ya existe
                String checkSql = "SELECT 1 FROM Productos WHERE lote_Producto = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setLong(1, Long.parseLong(loteParam));
                rs = pstmt.executeQuery();
                
                if(rs.next()) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=El número de lote ya existe");
                    return;
                }
                
                // Insertar nuevo producto con lote proporcionado por el usuario
                String sql = "INSERT INTO Productos (lote_Producto, nombre_De_Producto, id_Promocion, fecha_De_Caducidad, "
                           + "proveedor, precio_De_Venta, cantidad_En_Stock, departamento, marca_Del_Producto, "
                           + "fecha_De_Ingreso, codigo_De_Barras, estado) "
                           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                pstmt = conn.prepareStatement(sql);
                
                // Establecer parámetros
                pstmt.setLong(1, Long.parseLong(loteParam));
                pstmt.setString(2, nombre);
                pstmt.setObject(3, (idPromocionParam == null || idPromocionParam.isEmpty()) ? null : Integer.parseInt(idPromocionParam));
                pstmt.setDate(4, Date.valueOf(fechaCaducidad));
                pstmt.setString(5, proveedor);
                pstmt.setDouble(6, Double.parseDouble(precioParam));
                pstmt.setInt(7, Integer.parseInt(stockParam));
                pstmt.setString(8, departamento);
                pstmt.setString(9, marca.isEmpty() ? null : marca);
                pstmt.setDate(10, Date.valueOf(fechaIngreso));
                pstmt.setString(11, codigoBarras);
                pstmt.setString(12, estado);
                
                int rowsAffected = pstmt.executeUpdate();
                
                if(rowsAffected > 0) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=success&message=Producto agregado correctamente");
                } else {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Error al agregar producto");
                }
                
            } else if("update".equals(action) && loteParam != null) {
                // Actualizar producto existente
                String sql = "UPDATE Productos SET nombre_De_Producto = ?, id_Promocion = ?, fecha_De_Caducidad = ?, "
                           + "proveedor = ?, precio_De_Venta = ?, cantidad_En_Stock = ?, departamento = ?, "
                           + "marca_Del_Producto = ?, fecha_De_Ingreso = ?, codigo_De_Barras = ?, estado = ? "
                           + "WHERE lote_Producto = ?";
                
                pstmt = conn.prepareStatement(sql);
                
                // Establecer parámetros
                pstmt.setString(1, nombre);
                pstmt.setObject(2, (idPromocionParam == null || idPromocionParam.isEmpty()) ? null : Integer.parseInt(idPromocionParam));
                pstmt.setDate(3, Date.valueOf(fechaCaducidad));
                pstmt.setString(4, proveedor);
                pstmt.setDouble(5, Double.parseDouble(precioParam));
                pstmt.setInt(6, Integer.parseInt(stockParam));
                pstmt.setString(7, departamento);
                pstmt.setString(8, marca.isEmpty() ? null : marca);
                pstmt.setDate(9, Date.valueOf(fechaIngreso));
                pstmt.setString(10, codigoBarras);
                pstmt.setString(11, estado);
                pstmt.setLong(12, Long.parseLong(loteParam));
                
                int rowsAffected = pstmt.executeUpdate();
                
                if(rowsAffected > 0) {
                    response.sendRedirect("dashboardabarrotero.jsp?status=success&message=Producto actualizado correctamente");
                } else {
                    response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Error al actualizar producto o número de lote no encontrado");
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Formato de número inválido");
        } catch (IllegalArgumentException e) {
            response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Formato de fecha inválido");
        } catch (ClassNotFoundException | SQLException e) {
            response.sendRedirect("dashboardabarrotero.jsp?status=error&message=Error en la operación: " + e.getMessage());
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