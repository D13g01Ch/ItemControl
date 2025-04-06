<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Abarrotero - Productos</title>
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
        .product-management {
            max-width: 1200px;
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
        .product-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 0.9em;
        }
        .product-table th, .product-table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .product-table th {
            background-color: #007bff;
            color: white;
        }
        .product-table tr:nth-child(even) {
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
        .product-form {
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
            display: none;
        }
        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }
        .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, 
        .form-group select, 
        .form-group textarea {
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
            justify-content: flex-end;
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
        .expiring-soon {
            background-color: #ffeeba !important;
        }
        .expired {
            background-color: #f5c6cb !important;
        }
        .low-stock {
            background-color: #fff3cd;
        }
        .section-title {
            color: #007bff;
            margin-top: 30px;
            margin-bottom: 10px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="sidebar">  
        <h2>Menú</h2>    
        <a href="dashboardabarrotero.jsp">Inicio</a>
        <a href="dashboardabarrotero.jsp">Gestionar Invetario</a>
        <a href="login.jsp">Cerrar sesión</a>
    </div> 
    
    <div class="content">
        <img src="LOGOTIPO.png" alt="Logo" class="logo">
        
        <div class="product-management">
            <h2>Gestión de Productos</h2>
            
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
            
            <%-- Formulario de producto --%>
            <div id="productForm" class="product-form hidden">
                <h3 id="formTitle">Agregar Nuevo Producto</h3>
                <form id="productFormElement" action="ProductosServlet" method="POST" onsubmit="return validarFormulario()">
                    <input type="hidden" name="action" id="formAction" value="insert">
                    <input type="hidden" name="loteProducto" id="loteProductoHidden">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="loteProductoVisible">Número de Lote*</label>
                            <input type="number" id="loteProductoVisible" name="loteProductoVisible" required min="1">
                            <div id="loteProductoError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nombre">Nombre del Producto*</label>
                            <input type="text" id="nombre" name="nombre" required maxlength="50">
                            <div id="nombreError" class="error-message"></div>
                        </div>
                        <div class="form-group">
                            <label for="idPromocion">ID Promoción</label>
                            <input type="number" id="idPromocion" name="idPromocion" min="1">
                            <div id="idPromocionError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fechaCaducidad">Fecha de Caducidad*</label>
                            <input type="date" id="fechaCaducidad" name="fechaCaducidad" required>
                            <div id="fechaCaducidadError" class="error-message"></div>
                        </div>
                        <div class="form-group">
                            <label for="fechaIngreso">Fecha de Ingreso*</label>
                            <input type="date" id="fechaIngreso" name="fechaIngreso" required>
                            <div id="fechaIngresoError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="proveedor">Proveedor*</label>
                            <input type="text" id="proveedor" name="proveedor" required maxlength="50">
                            <div id="proveedorError" class="error-message"></div>
                        </div>
                        <div class="form-group">
                            <label for="departamento">Departamento*</label>
                            <input type="text" id="departamento" name="departamento" required maxlength="30">
                            <div id="departamentoError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="precio">Precio de Venta*</label>
                            <input type="number" id="precio" name="precio" step="0.01" min="0.01" required>
                            <div id="precioError" class="error-message"></div>
                        </div>
                        <div class="form-group">
                            <label for="stock">Cantidad en Stock*</label>
                            <input type="number" id="stock" name="stock" min="0" required>
                            <div id="stockError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="marca">Marca</label>
                            <input type="text" id="marca" name="marca" maxlength="30">
                            <div id="marcaError" class="error-message"></div>
                        </div>
                        <div class="form-group">
                            <label for="codigoBarras">Código de Barras*</label>
                            <input type="text" id="codigoBarras" name="codigoBarras" required maxlength="20">
                            <div id="codigoBarrasError" class="error-message"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="estado">Estado*</label>
                        <select id="estado" name="estado" required>
                            <option value="">Seleccione...</option>
                            <option value="disponible">Disponible</option>
                            <option value="agotado">Agotado</option>
                            <option value="descontinuado">Descontinuado</option>
                        </select>
                        <div id="estadoError" class="error-message"></div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="action-btn add-btn">Guardar</button>
                        <button type="button" onclick="hideProductForm()" class="action-btn delete-btn">Cancelar</button>
                    </div>
                </form>
            </div>
            
            <div class="action-buttons">
                <button onclick="showAddForm()" class="action-btn add-btn">Agregar Nuevo Producto</button>
            </div>
            
            <%-- Sección de productos próximos a caducar --%>
            <h3 class="section-title">Productos próximos a caducar (7 días o menos)</h3>
            <table class="product-table">
                <thead>
                    <tr>
                        <th>Lote</th>
                        <th>Nombre</th>
                        <th>Promoción</th>
                        <th>Caducidad</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Estado</th>
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
                        
                        // Obtener fecha actual y fecha límite (7 días después)
                        java.util.Date today = new java.util.Date();
                        java.sql.Date sqlToday = new java.sql.Date(today.getTime());
                        java.util.Calendar cal = java.util.Calendar.getInstance();
                        cal.setTime(today);
                        cal.add(java.util.Calendar.DATE, 7);
                        java.sql.Date sqlLimitDate = new java.sql.Date(cal.getTime().getTime());
                        
                        // Consulta para productos próximos a caducar (7 días o menos)
                        String sqlExpiring = "SELECT lote_Producto, nombre_De_Producto, id_Promocion, fecha_De_Caducidad, "
                                   + "precio_De_Venta, cantidad_En_Stock, estado, proveedor, departamento, "
                                   + "marca_Del_Producto, fecha_De_Ingreso, codigo_De_Barras FROM Productos "
                                   + "WHERE fecha_De_Caducidad BETWEEN ? AND ? "
                                   + "ORDER BY fecha_De_Caducidad ASC";
                        
                        PreparedStatement pstmtExpiring = conn.prepareStatement(sqlExpiring);
                        pstmtExpiring.setDate(1, sqlToday);
                        pstmtExpiring.setDate(2, sqlLimitDate);
                        ResultSet rsExpiring = pstmtExpiring.executeQuery();
                        
                        while(rsExpiring.next()) {
                            int stock = rsExpiring.getInt("cantidad_En_Stock");
                            String estado = rsExpiring.getString("estado");
                            java.sql.Date fechaCaducidad = rsExpiring.getDate("fecha_De_Caducidad");
                            
                            // Determinar clase CSS según fecha de caducidad
                            String rowClass = "";
                            if (fechaCaducidad.before(sqlToday)) {
                                rowClass = "expired";
                            } else {
                                rowClass = "expiring-soon";
                            }
                            
                            if (stock < 5) {
                                rowClass += " low-stock";
                            }
                %>
                    <tr class="<%= rowClass %>">
                        <td><%= rsExpiring.getInt("lote_Producto") %></td>
                        <td><%= rsExpiring.getString("nombre_De_Producto") %></td>
                        <td><%= rsExpiring.getObject("id_Promocion") != null ? rsExpiring.getInt("id_Promocion") : "N/A" %></td>
                        <td><%= fechaCaducidad %></td>
                        <td>$<%= String.format("%.2f", rsExpiring.getDouble("precio_De_Venta")) %></td>
                        <td><%= stock %></td>
                        <td><%= estado %></td>
                        <td>
                            <div class="action-buttons">
                                <button onclick='showEditForm(
                                    "<%= rsExpiring.getInt("lote_Producto") %>",
                                    "<%= rsExpiring.getString("nombre_De_Producto").replace("\"", "\\\"") %>",
                                    "<%= rsExpiring.getObject("id_Promocion") != null ? rsExpiring.getInt("id_Promocion") : "" %>",
                                    "<%= fechaCaducidad %>",
                                    "<%= rsExpiring.getDouble("precio_De_Venta") %>",
                                    "<%= stock %>",
                                    "<%= estado %>",
                                    "<%= rsExpiring.getString("proveedor") != null ? rsExpiring.getString("proveedor").replace("\"", "\\\"") : "" %>",
                                    "<%= rsExpiring.getString("departamento") != null ? rsExpiring.getString("departamento").replace("\"", "\\\"") : "" %>",
                                    "<%= rsExpiring.getString("marca_Del_Producto") != null ? rsExpiring.getString("marca_Del_Producto").replace("\"", "\\\"") : "" %>",
                                    "<%= rsExpiring.getDate("fecha_De_Ingreso") != null ? rsExpiring.getDate("fecha_De_Ingreso") : "" %>",
                                    "<%= rsExpiring.getString("codigo_De_Barras") != null ? rsExpiring.getString("codigo_De_Barras").replace("\"", "\\\"") : "" %>"
                                )' class="action-btn edit-btn">Editar</button>
                                <a href="ProductosServlet?action=delete&loteProducto=<%= rsExpiring.getInt("lote_Producto") %>" 
                                   class="action-btn delete-btn"
                                   onclick="return confirm('¿Estás seguro de eliminar este producto?')">Eliminar</a>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                        rsExpiring.close();
                        pstmtExpiring.close();
                        
                        // Sección para el resto de productos
                        out.println("</tbody></table>"); // Cerrar tabla anterior
                        
                        out.println("<h3 class='section-title'>Todos los productos</h3>");
                        out.println("<table class='product-table'>");
                        out.println("<thead><tr><th>Lote</th><th>Nombre</th><th>Promoción</th><th>Caducidad</th><th>Precio</th><th>Stock</th><th>Estado</th><th>Acciones</th></tr></thead>");
                        out.println("<tbody>");
                        
                        // Consulta para el resto de productos
                        String sqlAll = "SELECT lote_Producto, nombre_De_Producto, id_Promocion, fecha_De_Caducidad, "
                                   + "precio_De_Venta, cantidad_En_Stock, estado, proveedor, departamento, "
                                   + "marca_Del_Producto, fecha_De_Ingreso, codigo_De_Barras FROM Productos "
                                   + "WHERE fecha_De_Caducidad IS NULL OR fecha_De_Caducidad NOT BETWEEN ? AND ? "
                                   + "ORDER BY fecha_De_Caducidad ASC";
                        
                        PreparedStatement pstmtAll = conn.prepareStatement(sqlAll);
                        pstmtAll.setDate(1, sqlToday);
                        pstmtAll.setDate(2, sqlLimitDate);
                        ResultSet rsAll = pstmtAll.executeQuery();
                        
                        while(rsAll.next()) {
                            int stock = rsAll.getInt("cantidad_En_Stock");
                            String estado = rsAll.getString("estado");
                            java.sql.Date fechaCaducidad = rsAll.getDate("fecha_De_Caducidad");
                            
                            String rowClass = "";
                            if (fechaCaducidad != null && fechaCaducidad.before(sqlToday)) {
                                rowClass = "expired";
                            }
                            
                            if (stock < 5) {
                                rowClass += " low-stock";
                            }
                %>
                    <tr class="<%= rowClass %>">
                        <td><%= rsAll.getInt("lote_Producto") %></td>
                        <td><%= rsAll.getString("nombre_De_Producto") %></td>
                        <td><%= rsAll.getObject("id_Promocion") != null ? rsAll.getInt("id_Promocion") : "N/A" %></td>
                        <td><%= fechaCaducidad != null ? fechaCaducidad : "N/A" %></td>
                        <td>$<%= String.format("%.2f", rsAll.getDouble("precio_De_Venta")) %></td>
                        <td><%= stock %></td>
                        <td><%= estado %></td>
                        <td>
                            <div class="action-buttons">
                                <button onclick='showEditForm(
                                    "<%= rsAll.getInt("lote_Producto") %>",
                                    "<%= rsAll.getString("nombre_De_Producto").replace("\"", "\\\"") %>",
                                    "<%= rsAll.getObject("id_Promocion") != null ? rsAll.getInt("id_Promocion") : "" %>",
                                    "<%= fechaCaducidad != null ? fechaCaducidad.toString() : "" %>",
                                    "<%= rsAll.getDouble("precio_De_Venta") %>",
                                    "<%= stock %>",
                                    "<%= estado %>",
                                    "<%= rsAll.getString("proveedor") != null ? rsAll.getString("proveedor").replace("\"", "\\\"") : "" %>",
                                    "<%= rsAll.getString("departamento") != null ? rsAll.getString("departamento").replace("\"", "\\\"") : "" %>",
                                    "<%= rsAll.getString("marca_Del_Producto") != null ? rsAll.getString("marca_Del_Producto").replace("\"", "\\\"") : "" %>",
                                    "<%= rsAll.getDate("fecha_De_Ingreso") != null ? rsAll.getDate("fecha_De_Ingreso").toString() : "" %>",
                                    "<%= rsAll.getString("codigo_De_Barras") != null ? rsAll.getString("codigo_De_Barras").replace("\"", "\\\"") : "" %>"
                                )' class="action-btn edit-btn">Editar</button>
                                <a href="ProductosServlet?action=delete&loteProducto=<%= rsAll.getInt("lote_Producto") %>" 
                                   class="action-btn delete-btn"
                                   onclick="return confirm('¿Estás seguro de eliminar este producto?')">Eliminar</a>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                        rsAll.close();
                        pstmtAll.close();
                    } catch(Exception e) {
                        out.println("<div class='status-message error'>Error al cargar productos: " + e.getMessage() + "</div>");
                    } finally {
                        if(conn != null) try { conn.close(); } catch(Exception e) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Mostrar formulario para agregar
        function showAddForm() {
            document.getElementById('formTitle').textContent = 'Agregar Nuevo Producto';
            document.getElementById('formAction').value = 'insert';
            document.getElementById('loteProductoHidden').value = '';
            document.getElementById('loteProductoVisible').value = '';
            document.getElementById('loteProductoVisible').readOnly = false;
            
            // Resetear formulario
            const form = document.getElementById('productFormElement');
            form.reset();
            
            // Establecer fecha mínima (hoy)
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fechaIngreso').value = today;
            document.getElementById('fechaIngreso').min = today;
            
            resetErrors();
            document.getElementById('productForm').style.display = 'block';
        }
        
        // Mostrar formulario para editar con datos precargados
        function showEditForm(lote, nombre, idPromocion, fechaCaducidad, precio, stock, estado, 
                            proveedor, departamento, marca, fechaIngreso, codigoBarras) {
            document.getElementById('formTitle').textContent = 'Editar Producto';
            document.getElementById('formAction').value = 'update';
            document.getElementById('loteProductoHidden').value = lote;
            document.getElementById('loteProductoVisible').value = lote;
            document.getElementById('loteProductoVisible').readOnly = true;
            
            // Llenar campos
            document.getElementById('nombre').value = nombre;
            document.getElementById('idPromocion').value = idPromocion || '';
            document.getElementById('fechaCaducidad').value = fechaCaducidad ? fechaCaducidad.split(' ')[0] : '';
            document.getElementById('proveedor').value = proveedor || '';
            document.getElementById('precio').value = precio;
            document.getElementById('stock').value = stock;
            document.getElementById('departamento').value = departamento || '';
            document.getElementById('marca').value = marca || '';
            document.getElementById('fechaIngreso').value = fechaIngreso ? fechaIngreso.split(' ')[0] : '';
            document.getElementById('codigoBarras').value = codigoBarras || '';
            document.getElementById('estado').value = estado;
            
            resetErrors();
            document.getElementById('productForm').style.display = 'block';
        }
        
        // Ocultar formulario
        function hideProductForm() {
            document.getElementById('productForm').style.display = 'none';
        }
        
        // Validación del formulario
        function validarFormulario() {
            // Obtener elementos
            const loteProducto = document.getElementById("loteProductoVisible");
            const nombre = document.getElementById("nombre");
            const fechaCaducidad = document.getElementById("fechaCaducidad");
            const proveedor = document.getElementById("proveedor");
            const precio = document.getElementById("precio");
            const stock = document.getElementById("stock");
            const departamento = document.getElementById("departamento");
            const fechaIngreso = document.getElementById("fechaIngreso");
            const codigoBarras = document.getElementById("codigoBarras");
            const estado = document.getElementById("estado");
            const errorElement = document.getElementById("clientError");
            
            // Actualizar el campo hidden con el valor visible
            document.getElementById('loteProductoHidden').value = loteProducto.value;
            
            // Limpiar errores anteriores
            errorElement.textContent = "";
            errorElement.classList.add("hidden");
            resetErrors();
            
            // Validar campos vacíos
            let camposVacios = 0;
            if (loteProducto.value.trim() === "") camposVacios++;
            if (nombre.value.trim() === "") camposVacios++;
            if (fechaCaducidad.value.trim() === "") camposVacios++;
            if (proveedor.value.trim() === "") camposVacios++;
            if (precio.value.trim() === "") camposVacios++;
            if (stock.value.trim() === "") camposVacios++;
            if (departamento.value.trim() === "") camposVacios++;
            if (fechaIngreso.value.trim() === "") camposVacios++;
            if (codigoBarras.value.trim() === "") camposVacios++;
            if (estado.value === "") camposVacios++;
            
            // 1. Validar cuando faltan múltiples campos
            if (camposVacios > 1) {
                showError("Por favor rellene todos los campos obligatorios", errorElement);
                return false;
            }
            
            // 2. Validar campos individuales
            if (loteProducto.value.trim() === "") {
                showError("El número de lote es obligatorio", document.getElementById("loteProductoError"), loteProducto);
                return false;
            }
            
            if (parseInt(loteProducto.value) <= 0) {
                showError("El número de lote debe ser positivo", document.getElementById("loteProductoError"), loteProducto);
                return false;
            }
            
            if (nombre.value.trim() === "") {
                showError("El nombre del producto es obligatorio", document.getElementById("nombreError"), nombre);
                return false;
            }
            
            if (fechaCaducidad.value.trim() === "") {
                showError("La fecha de caducidad es obligatoria", document.getElementById("fechaCaducidadError"), fechaCaducidad);
                return false;
            }
            
            if (proveedor.value.trim() === "") {
                showError("El proveedor es obligatorio", document.getElementById("proveedorError"), proveedor);
                return false;
            }
            
            if (precio.value.trim() === "") {
                showError("El precio es obligatorio", document.getElementById("precioError"), precio);
                return false;
            }
            
            if (stock.value.trim() === "") {
                showError("El stock es obligatorio", document.getElementById("stockError"), stock);
                return false;
            }
            
            if (departamento.value.trim() === "") {
                showError("El departamento es obligatorio", document.getElementById("departamentoError"), departamento);
                return false;
            }
            
            if (fechaIngreso.value.trim() === "") {
                showError("La fecha de ingreso es obligatoria", document.getElementById("fechaIngresoError"), fechaIngreso);
                return false;
            }
            
            if (codigoBarras.value.trim() === "") {
                showError("El código de barras es obligatorio", document.getElementById("codigoBarrasError"), codigoBarras);
                return false;
            }
            
            if (estado.value === "") {
                showError("El estado es obligatorio", document.getElementById("estadoError"), estado);
                return false;
            }
            
            // 3. Validar fechas
            const fechaCad = new Date(fechaCaducidad.value);
            const fechaIng = new Date(fechaIngreso.value);
            
            if (fechaCad < fechaIng) {
                showError("La fecha de caducidad no puede ser anterior a la de ingreso", document.getElementById("fechaCaducidadError"), fechaCaducidad);
                return false;
            }
            
            // 4. Validar precio
            if (parseFloat(precio.value) <= 0) {
                showError("El precio debe ser mayor a cero", document.getElementById("precioError"), precio);
                return false;
            }
            
            // 5. Validar stock
            if (parseInt(stock.value) < 0) {
                showError("El stock no puede ser negativo", document.getElementById("stockError"), stock);
                return false;
            }
            
            // 6. Validar longitud de campos
            if (nombre.value.length > 50) {
                showError("El nombre no puede exceder 50 caracteres", document.getElementById("nombreError"), nombre);
                return false;
            }
            
            if (proveedor.value.length > 50) {
                showError("El proveedor no puede exceder 50 caracteres", document.getElementById("proveedorError"), proveedor);
                return false;
            }
            
            if (departamento.value.length > 30) {
                showError("El departamento no puede exceder 30 caracteres", document.getElementById("departamentoError"), departamento);
                return false;
            }
            
            if (document.getElementById("marca").value.length > 30) {
                showError("La marca no puede exceder 30 caracteres", document.getElementById("marcaError"), document.getElementById("marca"));
                return false;
            }
            
            if (codigoBarras.value.length > 20) {
                showError("El código de barras no puede exceder 20 caracteres", document.getElementById("codigoBarrasError"), codigoBarras);
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
            const fields = ["loteProductoVisible", "nombre", "idPromocion", "fechaCaducidad", "proveedor", "precio", 
                          "stock", "departamento", "marca", "fechaIngreso", "codigoBarras", "estado"];
            
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
            
            // Configurar fecha mínima al cargar la página
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('fechaIngreso').min = today;
        });
    </script>
</body>
</html>