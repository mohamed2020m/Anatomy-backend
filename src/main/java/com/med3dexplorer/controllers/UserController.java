package com.med3dexplorer.controllers;

import com.med3dexplorer.security.JwtAuthenticationFilter;
import com.med3dexplorer.services.interfaces.AdministratorService;
import com.med3dexplorer.services.interfaces.JwtService;
import com.med3dexplorer.services.interfaces.ProfessorService;
import com.med3dexplorer.services.interfaces.StudentService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/api/v1/me")
public class UserController {
    private static final Logger logger = Logger.getLogger(UserController.class.getName());

    private final AdministratorService adminService;
    private final StudentService studentService;
    private final ProfessorService professorService;
    private final JwtService jwtService;

    public UserController(AdministratorService adminService, StudentService studentService,
                          ProfessorService professorService, JwtService jwtService) {
        this.adminService = adminService;
        this.studentService = studentService;
        this.professorService = professorService;
        this.jwtService = jwtService;
    }

    @GetMapping
    public ResponseEntity<?> getCurrentUserInfo(HttpServletRequest request) {
        String token = jwtService.extractTokenFromRequest(request);
        String username = jwtService.extractUsername(token);

        List<String> roles = jwtService.extractRoles(token);
        String role = roles.isEmpty() ? null : roles.get(0);

        if ("ROLE_ADMIN".equals(role)) {
            return ResponseEntity.ok(adminService.getAdminInfo(username));
        } else if ("ROLE_STUD".equals(role)) {
            return ResponseEntity.ok(studentService.getStudentInfo(username));
        } else if ("ROLE_PROF".equals(role)) {
            return ResponseEntity.ok(professorService.getProfessorInfo(username));
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Role not recognized.");
        }
    }
}
