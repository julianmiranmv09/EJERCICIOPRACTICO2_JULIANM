/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package CasoWeb2.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


@Controller
@RequestMapping("/registro")
public class CategoriaController {
    

    @GetMapping("")
    public String mostrarRegistro(Model model) {
        model.addAttribute("pageTitle", "Registro - Praxair");
        model.addAttribute("pageDescription", "Crear una nueva cuenta en Praxair");
        
        return "registro"; // Busca en templates/registro.html
    }
    

    @GetMapping("/form")
    public String mostrarFormularioRegistro(Model model) {
        return "redirect:/registro";
    }
    

    @PostMapping("/procesar")
    public String procesarRegistro(
            @RequestParam String nombre,
            @RequestParam String apellido,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam String telefono,
            @RequestParam String direccion,
            RedirectAttributes redirectAttributes) {
        
        try {
            if (!validarCamposRequeridos(nombre, apellido, email, password, confirmPassword, telefono, direccion)) {
                redirectAttributes.addFlashAttribute("error", "Todos los campos son obligatorios");
                return "redirect:/registro";
            }
            
            if (!password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Las contraseñas no coinciden");
                return "redirect:/registro";
            }
            
            if (!validarPassword(password)) {
                redirectAttributes.addFlashAttribute("error", "La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas y números");
                return "redirect:/registro";
            }
            
            if (!validarEmail(email)) {
                redirectAttributes.addFlashAttribute("error", "Formato de email inválido");
                return "redirect:/registro";
            }
            
            boolean registroExitoso = registrarUsuario(nombre, apellido, email, password, telefono, direccion);
            
            if (registroExitoso) {
                redirectAttributes.addFlashAttribute("success", "¡Registro exitoso! Te hemos enviado un correo de confirmación.");
                
                return "redirect:/registro?success=true";
            } else {
                redirectAttributes.addFlashAttribute("error", "Error en el registro. El email ya está en uso.");
                return "redirect:/registro";
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error interno del servidor. Intenta nuevamente.");
            return "redirect:/registro";
        }
    }
    
    @GetMapping("/confirmacion")
    public String confirmacionRegistro(Model model) {
        model.addAttribute("pageTitle", "Registro Exitoso - Praxair");
        model.addAttribute("mensaje", "¡Registro completado exitosamente!");
        
        return "registro-confirmacion"; // Busca en templates/registro-confirmacion.html
    }
    
    private boolean validarCamposRequeridos(String... campos) {
        for (String campo : campos) {
            if (campo == null || campo.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }
    
    private boolean validarEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailRegex);
    }
    
    private boolean validarPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean tieneMayuscula = password.matches(".*[A-Z].*");
        boolean tieneMinuscula = password.matches(".*[a-z].*");
        boolean tieneNumero = password.matches(".*\\d.*");
        
        return tieneMayuscula && tieneMinuscula && tieneNumero;
    }

    private boolean validarTelefono(String telefono) {
        if (telefono == null || telefono.trim().isEmpty()) {
            return false;
        }
        
        String telefonoRegex = "^(\\+506\\s?)?[0-9]{4}[\\s-]?[0-9]{4}$";
        return telefono.replaceAll("\\s", "").matches(telefonoRegex);
    }

    private boolean registrarUsuario(String nombre, String apellido, String email, 
                                   String password, String telefono, String direccion) {
        
        if (email.equals("test@praxair.com")) {
            return false; // Email ya existe
        }

        System.out.println("Registrando usuario: " + nombre + " " + apellido + " - " + email);
        
        return true;
    }
    
    @GetMapping("/verificar-email")
    public String verificarEmail(@RequestParam String email, Model model) {
        boolean existe = email.equals("test@praxair.com");
        
        model.addAttribute("existe", existe);
        return "fragments/email-verificacion";
    }
}
