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

            // create categories
            Category mainCategory = Category.builder()
                    .name("Main Category")
                    .description("A primary category for 3D objects")
                    .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                    .build();
            categoryRepository.save(mainCategory);

            Category subCategory1 = Category.builder()
                    .name("Subcategory 1")
                    .description("First subcategory")
                    .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                    .parentCategory(mainCategory)
                    .build();
            categoryRepository.save(subCategory1);

            Category subCategory2 = Category.builder()
                    .name("Subcategory 2")
                    .description("Second subcategory")
                    .image("images-2aac1d72-2c70-4061-a3f6-251ae7e436f6.jpg")
                    .parentCategory(mainCategory)
                    .build();
            categoryRepository.save(subCategory2);

            // create professor
            Category getMainCat = categoryRepository.findByName("Main Category").orElseThrow();

            System.out.println("category: " + getMainCat.getName());

            String profEmail = "lachgar@example.com";
            String profPassword = "123456";

            if (!userRepository.existsByEmail(profEmail)){
                RegisterUserDTO prof = new RegisterUserDTO();
                prof.setEmail(profEmail);
                prof.setFirstName("Mohamed");
                prof.setLastName("lachgar");
                prof.setPassword(profPassword);
                prof.setCategory(getMainCat);
                prof.setRole("PROF");

                authenticationService.signup(prof);
                System.out.println("prof user created.");
            } else {
                System.out.println("prof user already exists.");
            }

            // create 3D objects
            Category sC1 = categoryRepository.findByName("Subcategory 1").orElseThrow();
            Category sC2 = categoryRepository.findByName("Subcategory 2").orElseThrow();
            Professor professor = professorRepository.findByEmail("lachgar@example.com").orElseThrow();

            ThreeDObject object1 = ThreeDObject.builder()
                    .name("3D Model 1")
                    .description("A sample 3D object in subcategory 1")
                    .object("objects-2aac1d72-2c70-4061-a3f6-251ae7e436f6.glb")
                    .image("images-98d4bd84-2af5-4bb6-8160-8b25de476293.jpg")
                    .category(sC1)
                    .professor(professor)
                    .build();
            threeDObjectRepository.save(object1);

            ThreeDObject object2 = ThreeDObject.builder()
                    .name("3D Model 2")
                    .description("A sample 3D object in subcategory 2")
                    .object("objects-3bbc1e72-2c70-4061-a3f6-951de7e446f8.glb")
                    .image("images-2514f0f1-84f8-4d03-a3bf-ad99032b1dfc.jpg")
                    .category(sC2)
                    .professor(professor)
                    .build();
            threeDObjectRepository.save(object2);
        };
    }
}

