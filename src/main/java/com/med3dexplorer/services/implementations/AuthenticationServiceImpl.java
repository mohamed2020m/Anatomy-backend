package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.LoginUserDTO;
import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.models.Administrator;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.models.Student;
import com.med3dexplorer.models.User;
import com.med3dexplorer.repositories.UserRepository;
import com.med3dexplorer.services.interfaces.AuthenticationService;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationServiceImpl implements AuthenticationService {
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private final AuthenticationManager authenticationManager;

    public AuthenticationServiceImpl(
            UserRepository userRepository,
            AuthenticationManager authenticationManager,
            PasswordEncoder passwordEncoder
    ) {
        this.authenticationManager = authenticationManager;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

//    public User signup(RegisterUserDto input) {
//        User user = User.builder()
//                .firstName(input.getFirstName())
//                .lastName(input.getLastName())
//                .email(input.getEmail())
//                .password(passwordEncoder.encode(input.getPassword()))
//
//                .build();
//        return userRepository.save(user);
//    }

    public User signup(RegisterUserDTO input) {
        User user;
        switch (input.getRole().toUpperCase()) {
            case "STUD":
                user = new Student();
                break;
            case "PROF":
                user = new Professor();
                break;
            case "ADMIN":
                user = new Administrator();
                break;
            default:
                throw new IllegalArgumentException("Invalid role specified: " + input.getRole());
        }

        user.setFirstName(input.getFirstName());
        user.setLastName(input.getLastName());
        user.setEmail(input.getEmail());
        user.setPassword(passwordEncoder.encode(input.getPassword()));

        return userRepository.save(user);
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