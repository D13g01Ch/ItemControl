/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Gerardo Adrian
 */
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.util.HashMap;

public class InicioSecion1 extends JFrame {

    // Base de datos de usuarios (simulada con HashMap)
    private HashMap<String, String> usuarios;

    public InicioSecion1() {
        setTitle("Inicio de Sesión");
        setSize(600, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Centrar ventana

        // Definir usuarios y contraseñas
        usuarios = new HashMap<>();
        usuarios.put("US1", "123456");
        usuarios.put("US2", "1234567");

        // Panel principal con GridLayout (2 columnas)
        JPanel mainPanel = new JPanel(new GridLayout(1, 2));

        // Panel izquierdo (Imagen desde Internet)
        JLabel imageLabel = new JLabel();
        try {
            URL imageUrl = new URL("https://i.imgur.com/b4cD78s.png"); // Cambia esta URL por tu imagen
            BufferedImage img = ImageIO.read(imageUrl);
            Image scaledImg = img.getScaledInstance(300, 400, Image.SCALE_SMOOTH);
            imageLabel.setIcon(new ImageIcon(scaledImg));
        } catch (Exception e) {
            imageLabel.setText("Error al cargar imagen");
        }
        imageLabel.setHorizontalAlignment(SwingConstants.CENTER);
        mainPanel.add(imageLabel);

        // Panel derecho (Blanco con formulario)
        JPanel loginPanel = new JPanel();
        loginPanel.setBackground(Color.decode("#3A5FCD"));
        loginPanel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.fill = GridBagConstraints.HORIZONTAL;
        
        JLabel userLabel = new JLabel("Usuario:");
        gbc.gridx = 0;
        gbc.gridy = 0;
        loginPanel.add(userLabel, gbc);

        JTextField userField = new JTextField(15);
        gbc.gridx = 1;
        loginPanel.add(userField, gbc);

        JLabel passLabel = new JLabel("Contraseña:");
        gbc.gridx = 0;
        gbc.gridy = 1;
        loginPanel.add(passLabel, gbc);

        JPasswordField passField = new JPasswordField(15);
        gbc.gridx = 1;
        loginPanel.add(passField, gbc);

        JButton loginButton = new JButton("Iniciar Sesión");
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        loginPanel.add(loginButton, gbc);

        mainPanel.add(loginPanel);
        add(mainPanel);

        // Acción del botón
        loginButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String usuario = userField.getText();
                String contraseña = new String(passField.getPassword());

                // Verificar credenciales
                if (usuarios.containsKey(usuario) && usuarios.get(usuario).equals(contraseña)) {
                    JOptionPane.showMessageDialog(null, "Inicio de sesión exitoso.");
                    abrirNuevaVentana();
                } else {
                    JOptionPane.showMessageDialog(null, "Usuario o contraseña incorrectos.", "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });

        setVisible(true);
    }

    // Método para abrir una nueva ventana
    private void abrirNuevaVentana() {
        JFrame nuevaVentana = new JFrame("Bienvenido");
        nuevaVentana.setSize(400, 300);
        nuevaVentana.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        nuevaVentana.setLocationRelativeTo(null);
/////////////////////////////////////ELIMINAR/////////////////////////////////////////////////
        JLabel mensaje = new JLabel("¡Bienvenido al sistema!", SwingConstants.CENTER);
        mensaje.setFont(new Font("Arial", Font.BOLD, 18));

        nuevaVentana.add(mensaje);
        nuevaVentana.setVisible(true);
 ///////////////////////////////////////////////////////////////////////////////////////////
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new InicioSecion1());
    }
}