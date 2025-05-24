/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.is2.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;

@WebServlet(name = "ObtenerProductosServlet", urlPatterns = {"/ObtenerProductosServlet"})
public class ObtenerProductosServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Connection conn = null;
        List<Map<String, Object>> productos = new ArrayList<>();
        Gson gson = new Gson();
        
        try {
            // 1. Cargar el driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // 2. Establecer conexión
            String connectionUrl = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=ITEMCONTROL;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;"
                    + "user=Administrador;"
                    + "password=Administrador";
            
            conn = DriverManager.getConnection(connectionUrl);
            
            // 3. Consulta SQL para obtener todos los productos con fecha de caducidad
            String sql = "SELECT lote_Producto, nombre_De_Producto, fecha_De_Caducidad, "
                       + "precio_De_Venta, cantidad_En_Stock, proveedor "
                       + "FROM Productos WHERE fecha_De_Caducidad IS NOT NULL "
                       + "ORDER BY fecha_De_Caducidad ASC";
            
            // 4. Ejecutar consulta
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                
                // 5. Procesar resultados
                while (rs.next()) {
                    Map<String, Object> producto = new HashMap<>();
                    producto.put("lote_Producto", rs.getInt("lote_Producto"));
                    producto.put("nombre_De_Producto", rs.getString("nombre_De_Producto"));
                    producto.put("fecha_De_Caducidad", rs.getString("fecha_De_Caducidad"));
                    producto.put("precio_De_Venta", rs.getDouble("precio_De_Venta"));
                    producto.put("cantidad_En_Stock", rs.getInt("cantidad_En_Stock"));
                    producto.put("proveedor", rs.getString("proveedor"));
                    
                    productos.add(producto);
                }
            }
            
            // 6. Configurar respuesta JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(productos));
            
        } catch (ClassNotFoundException | SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Error al obtener productos: " + e.getMessage() + "\"}");
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
}