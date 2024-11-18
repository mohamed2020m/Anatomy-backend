package com.terraViva;

import com.terraViva.repositories.UserRepository;
import com.terraViva.services.implementations.AuthenticationServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TerraVivaApplication {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticationServiceImpl authenticationService;


    public static void main(String[] args) {
        SpringApplication.run(TerraVivaApplication.class, args);
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
