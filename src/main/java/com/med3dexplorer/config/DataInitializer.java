package com.med3dexplorer.config;

import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.models.Category;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.models.ThreeDObject;
import com.med3dexplorer.repositories.CategoryRepository;
import com.med3dexplorer.repositories.ProfessorRepository;
import com.med3dexplorer.repositories.ThreeDObjectRepository;
import com.med3dexplorer.repositories.UserRepository;
import com.med3dexplorer.services.implementations.AuthenticationServiceImpl;
import com.med3dexplorer.services.implementations.ProfessorServiceImpl;
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
            ThreeDObjectRepository threeDObjectRepository
    ) {
        return args -> {
            // create admin
            String adminEmail = "admin@admin.com";
            String adminPassword = "123456";

            if (!userRepository.existsByEmail(adminEmail)){
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

            // Create categories if they don't exist
            Category mainCategory = categoryRepository.findByName("Main Category")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Main Category")
                                .description("A primary category for 3D objects")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .build();
                        return categoryRepository.save(category);
                    });

            Category subCategory1 = categoryRepository.findByName("Subcategory 1")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Subcategory 1")
                                .description("First subcategory")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .parentCategory(mainCategory)
                                .build();
                        return categoryRepository.save(category);
                    });

            Category subCategory2 = categoryRepository.findByName("Subcategory 2")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Subcategory 2")
                                .description("Second subcategory")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .parentCategory(mainCategory)
                                .build();
                        return categoryRepository.save(category);
                    });


            // create professor
            String profEmail = "lachgar@example.com";
            if (!userRepository.existsByEmail(profEmail)){
                RegisterUserDTO prof = new RegisterUserDTO();
                prof.setEmail(profEmail);
                prof.setFirstName("Mohamed");
                prof.setLastName("lachgar");
                prof.setPassword("123456");
                prof.setCategory(mainCategory);
                prof.setRole("PROF");

                authenticationService.signup(prof);
                System.out.println("prof user created.");
            } else {
                System.out.println("prof user already exists.");
            }

            // Create 3D objects if they don't exist
            Professor professor = professorRepository.findByEmail(profEmail).orElseThrow();

            threeDObjectRepository.findByName("3D Model 1")
                    .orElseGet(() -> {
                        ThreeDObject object1 = ThreeDObject.builder()
                                .name("3D Model 1")
                                .description("A sample 3D object in subcategory 1")
                                .object("objects-2aac1d72-2c70-4061-a3f6-251ae7e436f6.glb")
                                .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                                .category(subCategory1)
                                .professor(professor)
                                .build();
                        return threeDObjectRepository.save(object1);
                    });

            threeDObjectRepository.findByName("3D Model 2")
                    .orElseGet(() -> {
                        ThreeDObject object2 = ThreeDObject.builder()
                                .name("3D Model 2")
                                .description("A sample 3D object in subcategory 2")
                                .object("objects-3bbc1e72-2c70-4061-a3f6-951de7e446f8.glb")
                                .image("images-2514f0f1-84f8-4d03-a3bf-ad99032b1dfc.jpg")
                                .category(subCategory2)
                                .professor(professor)
                                .build();
                        return threeDObjectRepository.save(object2);
                    });
        };
    }
}

