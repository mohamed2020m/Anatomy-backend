package com.terraViva.controllers;

import com.terraViva.dto.AdministratorDTO;
import com.terraViva.dto.ProfessorDTO;
import com.terraViva.dto.StudentDTO;
import com.terraViva.models.Role;
import com.terraViva.services.interfaces.AdministratorService;
import com.terraViva.services.interfaces.JwtService;
import com.terraViva.services.interfaces.ProfessorService;
import com.terraViva.services.interfaces.StudentService;
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
            AdministratorDTO admin = adminService.getAdminInfo(username);
            admin.setRole(Role.ROLE_ADMIN.name());
            return ResponseEntity.ok(admin);
        } else if ("ROLE_STUD".equals(role)) {
            StudentDTO studentDTO = studentService.getStudentInfo(username);
            studentDTO.setRole(Role.ROLE_STUD.name());
            return ResponseEntity.ok(studentDTO);
        } else if ("ROLE_PROF".equals(role)) {
            ProfessorDTO professorDTO = professorService.getProfessorInfo(username);
            professorDTO.setRole(Role.ROLE_PROF.name());
            return ResponseEntity.ok(professorDTO);
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("Role not recognized.");
        }
    }
}
