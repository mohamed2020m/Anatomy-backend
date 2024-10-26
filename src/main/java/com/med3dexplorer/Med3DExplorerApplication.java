package com.med3dexplorer;

import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.repositories.UserRepository;
import com.med3dexplorer.services.implementations.AuthenticationServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.LocalDateTime;

@SpringBootApplication
public class Med3DExplorerApplication {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticationServiceImpl authenticationService;


    public static void main(String[] args) {
        SpringApplication.run(Med3DExplorerApplication.class, args);
    }

//    @Bean
//    public CommandLineRunner createAdminUser() {
//        return args -> {
//            String adminEmail = "admin@admin.com";
//            String adminPassword = "123456";
//
//            if (!userRepository.existsByEmail(adminEmail)){
//                RegisterUserDTO admin = new RegisterUserDTO();
//                admin.setEmail(adminEmail);
//                admin.setFirstName("Admin");
//                admin.setLastName("Admin");
//                admin.setPassword(adminPassword);
//                admin.setRole("ADMIN");
//
//                authenticationService.signup(admin);
//                System.out.println("Admin user created.");
//            } else {
//                System.out.println("Admin user already exists.");
//            }
//        };
//    }
}
