/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.is;

// Importación de clases necesarias para trabajar con SQL y la interfaz gráfica
import java.sql.Connection;
import java.sql.DriverManager;
import javax.swing.JOptionPane;

/**
 * Clase encargada de manejar la conexión con la base de datos SQL Server.
 * Se establecen las credenciales necesarias para la conexión y se maneja la 
 * conexión en caso de éxito o error.
 *
 * @author Lluvia Alejandra
 */
public class ConexionSQLServer {
    
    // Variable para almacenar la conexión a la base de datos
    Connection conectar = null;
    
    // CREDENCIALES DE CONEXIÓN
    String usuario = "Administrador";  // Nombre de usuario para la conexión
    String contraseña = "Administrador";  // Contraseña para la conexión
    String bd = "ITEMCONTROL";  // Nombre de la base de datos a la que nos conectamos
    String ip = "localhost";  // Dirección IP del servidor de base de datos (en este caso, es local)
    String puerto = "1433";  // Puerto de conexión (el puerto por defecto de SQL Server es 1433)
    
    // Cadena de conexión JDBC, que define cómo conectarse a SQL Server
    String cadena = "jdbc:sqlserver://"+ip+":"+puerto+"/"+bd; 

   /**
    * Método que establece la conexión con la base de datos utilizando las 
    * credenciales definidas previamente.
    * 
    * @return conecta La conexión a la base de datos si la conexión es exitosa, o null si falla.
    */
   public Connection establecerConexion(){
       try {   
           // Cadena de conexión que especifica el servidor, puerto, base de datos y otras configuraciones
           String cadena = "jdbc:sqlserver://localhost:1433;databaseName=ITEMCONTROL;encrypt=true;trustServerCertificate=true";
           
           // Intento de establecer la conexión usando las credenciales y la cadena de conexión
           conectar = DriverManager.getConnection(cadena, usuario, contraseña);
           
           // Si la conexión es exitosa, muestra un mensaje de éxito
           JOptionPane.showMessageDialog(null, "Conexion exitosa a Base de Datos");
       } catch (Exception e) {
           // Si ocurre un error, muestra un mensaje de error con la descripción del problema
           JOptionPane.showMessageDialog(null, "Error de Conexion a BD, ERROR:" + e.toString());
       }
       // Devuelve la conexión establecida o null en caso de error
       return conectar;
       
       // Comentarios sobre el uso del driver:
       // Se necesita descargar el driver JDBC para SQL Server. 
       // NetBeans no maneja el driver de forma automática, así que se debe agregar manualmente al proyecto.
       // Esto se puede hacer agregando el archivo del driver al archivo pom.xml de Maven (si se usa Maven), 
       // y al guardar el archivo, el driver se descargará automáticamente.
   }

   /**
    * Método principal que crea una instancia de la clase ConexionSQLServer
    * y establece la conexión con la base de datos.
    */
   public static void main(String [] args){
       // Se crea una instancia de la clase ConexionSQLServer
       ConexionSQLServer objetoconexion = new ConexionSQLServer();
       
       // Se establece la conexión con la base de datos
       objetoconexion.establecerConexion();
   }  
}
// EL DRIVER JDBC de SQL Server permite a las aplicaciones Java interactuar con bases de datos.
// Este driver actúa como intermediario entre NetBeans y la base de datos SQL Server, 
// gestionando las conexiones y las consultas a la base de datos.
