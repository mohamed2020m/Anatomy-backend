package com.terraViva.services.implementations;

import com.terraViva.controllers.UserController;
import com.terraViva.dto.LoginUserDTO;
import com.terraViva.dto.RegisterUserDTO;
import com.terraViva.models.Administrator;
import com.terraViva.models.Professor;
import com.terraViva.models.Student;
import com.terraViva.models.User;
import com.terraViva.repositories.AdministratorRepository;
import com.terraViva.repositories.ProfessorRepository;
import com.terraViva.repositories.StudentRepository;
import com.terraViva.repositories.UserRepository;
import com.terraViva.services.interfaces.AuthenticationService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.logging.Logger;

@Service
public class AuthenticationServiceImpl implements AuthenticationService {
    private static final Logger logger = Logger.getLogger(UserController.class.getName());

    private final StudentRepository studentRepository;
    private final ProfessorRepository professorRepository;
    private final AdministratorRepository administratorRepository;
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final AuthenticationManager authenticationManager;

    public AuthenticationServiceImpl(
            StudentRepository studentRepository, ProfessorRepository professorRepository, AdministratorRepository administratorRepository, UserRepository userRepository, AuthenticationManager authenticationManager,
            PasswordEncoder passwordEncoder
    ) {
        this.studentRepository = studentRepository;
        this.professorRepository = professorRepository;
        this.administratorRepository = administratorRepository;
        this.userRepository = userRepository;
        this.authenticationManager = authenticationManager;
        this.passwordEncoder = passwordEncoder;
    }

    public User signup(RegisterUserDTO input) {
        switch (input.getRole().toUpperCase()) {
            case "STUD":
                Student student = new Student();
                student.setFirstName(input.getFirstName());
                student.setLastName(input.getLastName());
                student.setEmail(input.getEmail());
                student.setPassword(passwordEncoder.encode(input.getPassword()));
                return studentRepository.save(student);
            case "PROF":
                Professor professor = new Professor();
                professor.setFirstName(input.getFirstName());
                professor.setLastName(input.getLastName());
                professor.setEmail(input.getEmail());
                professor.setPassword(passwordEncoder.encode(input.getPassword()));
                professor.setCategory(input.getCategory());
                return professorRepository.save(professor);
            case "ADMIN":
                Administrator administrator = new Administrator();
                administrator.setFirstName(input.getFirstName());
                administrator.setLastName(input.getLastName());
                administrator.setEmail(input.getEmail());
                administrator.setPassword(passwordEncoder.encode(input.getPassword()));
                return administratorRepository.save(administrator);
            default:
                throw new IllegalArgumentException("Invalid role specified: " + input.getRole());
        }
    }
    public User authenticate(LoginUserDTO input) {
        authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                input.getEmail(),
                input.getPassword()
            )
        );

        return userRepository.findByEmail(input.getEmail())
            .orElseThrow();
    }
}