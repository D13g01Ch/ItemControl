/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ingenieriadesoftware;

/**
 *
 * @author diego
 */
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.net.URL;

public class InicioSesion extends JFrame {

    public InicioSesion() {
        setTitle("Inicio de Sesión");
        setSize(600, 400);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Centrar ventana

        // Panel principal con GridLayout (2 columnas)
        JPanel mainPanel = new JPanel(new GridLayout(1, 2));

        // Panel izquierdo (Imagen desde un enlace de Internet)
        JLabel imageLabel = new JLabel();
        try {
            URL imageUrl = new URL("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fes%2Ffotos%2Fnegocio&psig=AOvVaw3-edLrx7sZiJWcB57sKq4q&ust=1739644852784000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNiMtaDow4sDFQAAAAAdAAAAABAE"); // Cambia el enlace aquí
            ImageIcon icon = new ImageIcon(imageUrl);
            Image img = icon.getImage().getScaledInstance(300, 400, Image.SCALE_SMOOTH);
            imageLabel.setIcon(new ImageIcon(img));
        } catch (Exception e) {
            imageLabel.setText("Error al cargar la imagen");
        }
        imageLabel.setHorizontalAlignment(SwingConstants.CENTER);
        mainPanel.add(imageLabel);

        // Panel derecho (Blanco con formulario)
        JPanel loginPanel = new JPanel();
        loginPanel.setBackground(Color.WHITE);
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

                if (!usuario.isEmpty() && !contraseña.isEmpty()) {
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

        JLabel mensaje = new JLabel("¡Bienvenido al sistema!", SwingConstants.CENTER);
        mensaje.setFont(new Font("Arial", Font.BOLD, 18));

        nuevaVentana.add(mensaje);
        nuevaVentana.setVisible(true);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new InicioSesion());
    }
}