package com.med3dexplorer.services.implementations;

import com.med3dexplorer.controllers.UserController;
import com.med3dexplorer.dto.LoginUserDTO;
import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.models.Administrator;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.models.Student;
import com.med3dexplorer.models.User;
import com.med3dexplorer.repositories.AdministratorRepository;
import com.med3dexplorer.repositories.ProfessorRepository;
import com.med3dexplorer.repositories.StudentRepository;
import com.med3dexplorer.repositories.UserRepository;
import com.med3dexplorer.services.interfaces.AuthenticationService;
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