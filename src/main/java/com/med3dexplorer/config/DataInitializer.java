package com.med3dexplorer.config;

import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.models.Category;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.models.ThreeDObject;
import com.med3dexplorer.repositories.*;
import com.med3dexplorer.services.implementations.AuthenticationServiceImpl;
import com.med3dexplorer.services.implementations.ProfessorServiceImpl;
import com.med3dexplorer.services.interfaces.AuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataInitializer {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticationServiceImpl authenticationService;

    @Bean
    public CommandLineRunner initializeDB(
            CategoryRepository categoryRepository,
            ProfessorRepository professorRepository,
            ThreeDObjectRepository threeDObjectRepository,
            StudentRepository studentRepository,
            UserRepository userRepository,
            AuthenticationService authenticationService
    ) {
        return args -> {
            // Créer l'administrateur
            String adminEmail = "admin@admin.com";
            String adminPassword = "123456";

            if (!userRepository.existsByEmail(adminEmail)) {
                RegisterUserDTO admin = new RegisterUserDTO();
                admin.setEmail(adminEmail);
                admin.setFirstName("Admin");
                admin.setLastName("Admin");
                admin.setPassword(adminPassword);
                admin.setRole("ADMIN");

                authenticationService.signup(admin);
                System.out.println("Admin user created.");
            } else {
                System.out.println("Admin user already exists.");
            }

            // Creating of main category
            Category anatomyCategory = categoryRepository.findByName("Anatomy")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Anatomy")
                                .description("3D models of human anatomy structures")
                                .image("images-0d6f1622-ab33-40cb-9fac-6a2023e8c8c3.jpg")
                                .build();
                        return categoryRepository.save(category);
                    });

            Category cardiovascularSystem = categoryRepository.findByName("Cardiovascular System")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Cardiovascular System")
                                .description("Models of heart, blood vessels, and circulatory system")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .parentCategory(anatomyCategory)
                                .build();
                        return categoryRepository.save(category);
                    });

            Category digestiveSystem = categoryRepository.findByName("Digestive System")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Digestive System")
                                .description("Models of stomach, intestines, and other digestive organs")
                                .image("images-dfhks12ls-ab33-40cb-9fac-6a2023e8c8c3.jpg")
                                .parentCategory(anatomyCategory)
                                .build();
                        return categoryRepository.save(category);
                    });

            String profEmail0 = "mohamed.lachgar@example.com";
            if (!userRepository.existsByEmail(profEmail0)) {
                RegisterUserDTO prof0 = new RegisterUserDTO();
                prof0.setEmail(profEmail0);
                prof0.setFirstName("Mohamed");
                prof0.setLastName("Lachgar");
                prof0.setPassword("123456");
                prof0.setCategory(anatomyCategory);
                prof0.setRole("PROF");

                authenticationService.signup(prof0);
                System.out.println("Professor Mohamed Lachgar created.");
            } else {
                System.out.println("Professor Mohamed Lachgar already exists.");
            }

            String profEmail1 = "hamza.alami@example.com";
            if (!userRepository.existsByEmail(profEmail1)) {
                RegisterUserDTO prof1 = new RegisterUserDTO();
                prof1.setEmail(profEmail1);
                prof1.setFirstName("Hamza");
                prof1.setLastName("Alami");
                prof1.setPassword("123456");
                prof1.setCategory(anatomyCategory);
                prof1.setRole("PROF");

                authenticationService.signup(prof1);
                System.out.println("Professor Hamza Alami created.");
            } else {
                System.out.println("Professor Hamza Alami already exists.");
            }

            String profEmail2 = "sara.elhaddad@example.com";
            if (!userRepository.existsByEmail(profEmail2)) {
                RegisterUserDTO prof2 = new RegisterUserDTO();
                prof2.setEmail(profEmail2);
                prof2.setFirstName("Sara");
                prof2.setLastName("El Haddad");
                prof2.setPassword("123456");
                prof2.setCategory(anatomyCategory);
                prof2.setRole("PROF");

                authenticationService.signup(prof2);
                System.out.println("Professor Sara El Haddad created.");
            } else {
                System.out.println("Professor Sara El Haddad already exists.");
            }

            // Creation of sub categories for a category
            Professor professor1 = professorRepository.findByEmail(profEmail1).orElseThrow();
            Professor professor2 = professorRepository.findByEmail(profEmail2).orElseThrow();

            threeDObjectRepository.findByName("Heart Model")
                    .orElseGet(() -> {
                        ThreeDObject heartModel = ThreeDObject.builder()
                                .name("Heart Model")
                                .description("Detailed 3D model of the human heart")
                                .object("objects/heart-model.glb")
                                .image("images-dfhks12ls-ab33-40cb-9fac-6a2023e8c8c3.jpg")
                                .category(cardiovascularSystem)
                                .professor(professor1)
                                .build();
                        return threeDObjectRepository.save(heartModel);
                    });

            threeDObjectRepository.findByName("Stomach Model")
                    .orElseGet(() -> {
                        ThreeDObject stomachModel = ThreeDObject.builder()
                                .name("Stomach Model")
                                .description("Detailed 3D model of the human stomach")
                                .object("objects/stomach-model.glb")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .category(digestiveSystem)
                                .professor(professor2)
                                .build();
                        return threeDObjectRepository.save(stomachModel);
                    });

            threeDObjectRepository.findByName("Intestines Model")
                    .orElseGet(() -> {
                        ThreeDObject intestinesModel = ThreeDObject.builder()
                                .name("Intestines Model")
                                .description("Detailed 3D model of the human intestines")
                                .object("objects/intestines-model.glb")
                                .image("images-0d6f1622-ab33-40cb-9fac-6a2023e8c8c3.jpg")
                                .category(digestiveSystem)
                                .professor(professor2)
                                .build();
                        return threeDObjectRepository.save(intestinesModel);
                    });

            // Créer des étudiants
            String studentEmail1 = "youssef.benali@student.com";
            if (!userRepository.existsByEmail(studentEmail1)) {
                RegisterUserDTO student1 = new RegisterUserDTO();
                student1.setEmail(studentEmail1);
                student1.setFirstName("Youssef");
                student1.setLastName("Benali");
                student1.setPassword("123456");
               // student1.getCategories().add(anatomyCategory);
                student1.setRole("STUD");

                authenticationService.signup(student1);
                System.out.println("Student Youssef Benali created.");
            } else {
                System.out.println("Student Youssef Benali already exists.");
            }

            String studentEmail2 = "nadia.abbas@student.com";
            if (!userRepository.existsByEmail(studentEmail2)) {
                RegisterUserDTO student2 = new RegisterUserDTO();
                student2.setEmail(studentEmail2);
                student2.setFirstName("Nadia");
                student2.setLastName("Abbas");
                student2.setPassword("123456");
               // student2.getCategories().add(anatomyCategory);
                student2.setRole("STUD");

                authenticationService.signup(student2);
                System.out.println("Student Nadia Abbas created.");
            } else {
                System.out.println("Student Nadia Abbas already exists.");
            }
        };
    }

}

