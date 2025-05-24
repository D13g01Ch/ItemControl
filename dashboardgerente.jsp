<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Gerente</title>
    <style>
        body {
            background: url('FONDO3new.png') no-repeat center center/cover;
            font-family: Arial, sans-serif;
            display: flex;
            min-height: 100vh;
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
            flex-grow: 1;
            text-align: center;
        }
        .logo {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            animation: spin 5s linear infinite;
        }
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        h2 {
            color: white;
            background-color: #007bff;
            padding: 10px;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        .product-table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            border-radius: 10px;
            overflow: hidden;
        }
        .product-table th, .product-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        .product-table th {
            background-color: #007bff;
            color: white;
            position: sticky;
            top: 0;
        }
        .product-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .urgente {
            background-color: #ffdddd;
        }
        .sin-promocion {
            color: #666;
            font-style: italic;
        }
        .error-message {
            color: red;
            padding: 10px;
            margin: 20px;
            border: 1px solid red;
            border-radius: 5px;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="sidebar">  
        <h2>Menú</h2>    
        <a href="dashboardgerente.jsp">Inicio</a>
        <a href="UsuariosGerente.jsp">Administrar Usuarios</a>
        <a href="DescuentosGerente.jsp">Administrar Descuentos</a>
        <a href="PDFGERENTE.jsp">Reporte de caducidad </a>
            <a href="login.jsp">Cerrar sesión</a>
    </div> 
    
    <div class="content">
        <img src="LOGOTIPO.png" alt="Logo" class="logo">
        
        <%! 
            private Connection getConnection() throws SQLException, ClassNotFoundException {
                String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
                String url = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
                String user = "Administrador";
                String pass = "Administrador";
                
                Class.forName(driver);
                return DriverManager.getConnection(url, user, pass);
            }
        %>
        
        <!-- Sección de Productos Próximos a Caducar -->
        <h2>Productos próximos a caducar</h2>
        <table class="product-table">
            <thead>
                <tr>
                    <th>Lote</th>
                    <th>Nombre</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Proveedor</th>
                    <th>Departamento</th>
                    <th>Fecha Caducidad</th>
                    <th>Días restantes</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection connProductos = null;
                try {
                    connProductos = getConnection();
                    
                    String sqlProductos = "SELECT TOP 3 lote_Producto as lote, nombre_De_Producto as nombre, " +
                                         "precio_De_Venta as precio, cantidad_En_Stock as stock, " +
                                         "proveedor, departamento, fecha_De_Caducidad as caducidad " +
                                         "FROM productos ORDER BY fecha_De_Caducidad ASC";
                    
                    Statement stmtProductos = connProductos.createStatement();
                    ResultSet rsProductos = stmtProductos.executeQuery(sqlProductos);
                    
                    while(rsProductos.next()) {
                        java.sql.Date fechaCad = rsProductos.getDate("caducidad");
                        long diff = fechaCad.getTime() - new java.util.Date().getTime();
                        long diasRestantes = diff / (1000 * 60 * 60 * 24);
                        String claseFila = diasRestantes <= 7 ? "urgente" : "";
            %>
                <tr class="<%= claseFila %>">
                    <td><%= rsProductos.getString("lote") %></td>
                    <td><%= rsProductos.getString("nombre") %></td>
                    <td>$<%= rsProductos.getDouble("precio") %></td>
                    <td><%= rsProductos.getInt("stock") %></td>
                    <td><%= rsProductos.getString("proveedor") %></td>
                    <td><%= rsProductos.getString("departamento") %></td>
                    <td><%= fechaCad %></td>
                    <td><%= diasRestantes %> días</td>
                    
                </tr>
            <%
                    }
                    rsProductos.close();
                    stmtProductos.close();
                } catch(Exception e) {
                    out.println("<div class='error-message'>Error al cargar productos: " + e.getMessage() + "</div>");
                } finally {
                    if(connProductos != null) try { connProductos.close(); } catch(Exception e) {}
                }
            %>
            </tbody>
        </table>
        
        <!-- Sección de Todos los Productos -->
        <h2>Todos los productos</h2>
        <table class="product-table">
            <thead>
                <tr>
                    <th>Lote</th>
                    <th>Nombre</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Proveedor</th>
                    <th>Departamento</th>
                    <th>Marca</th>
                    <th>Fecha Ingreso</th>
                    <th>Fecha Caducidad</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
            <%
                Connection connTodos = null;
                try {
                    connTodos = getConnection();
                    
                    String sqlTodos = "SELECT lote_Producto as lote, nombre_De_Producto as nombre, " +
                                     "precio_De_Venta as precio, cantidad_En_Stock as stock, " +
                                     "proveedor, departamento, marca_Del_Producto as marca, " +
                                     "fecha_De_Ingreso as ingreso, fecha_De_Caducidad as caducidad, " +
                                     "estado as estado " +
                                     "FROM productos ORDER BY nombre";
                    
                    Statement stmtTodos = connTodos.createStatement();
                    ResultSet rsTodos = stmtTodos.executeQuery(sqlTodos);
                    
                    while(rsTodos.next()) {
                        java.sql.Date fechaCad = rsTodos.getDate("caducidad");
                        java.sql.Date fechaIng = rsTodos.getDate("ingreso");
                        long diff = fechaCad.getTime() - new java.util.Date().getTime();
                        long diasRestantes = diff / (1000 * 60 * 60 * 24);
                        String claseFila = diasRestantes <= 7 ? "urgente" : "";
            %>
                <tr class="<%= claseFila %>">
                    <td><%= rsTodos.getString("lote") %></td>
                    <td><%= rsTodos.getString("nombre") %></td>
                    <td>$<%= rsTodos.getDouble("precio") %></td>
                    <td><%= rsTodos.getInt("stock") %></td>
                    <td><%= rsTodos.getString("proveedor") %></td>
                    <td><%= rsTodos.getString("departamento") %></td>
                    <td><%= rsTodos.getString("marca") %></td>
                    <td><%= fechaIng %></td>
                    <td><%= fechaCad %></td>
                    <td><%= rsTodos.getString("estado") %></td>
                                   </tr>
            <%
                    }
                    rsTodos.close();
                    stmtTodos.close();
                } catch(Exception e) {
                    out.println("<div class='error-message'>Error al cargar todos los productos: " + e.getMessage() + "</div>");
                } finally {
                    if(connTodos != null) try { connTodos.close(); } catch(Exception e) {}
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>