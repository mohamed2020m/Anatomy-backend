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
            // Create admin user
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
            }

            // Main Categories Creation
            // 1. Anatomy Category
            Category anatomyCategory = categoryRepository.findByName("Anatomy")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Anatomy")
                                .description("3D models of human anatomy structures")
                                .image("images-anatomy-main.jpg")
                                .build();
                        return categoryRepository.save(category);
                    });

            // Anatomy subcategories
            Category cardiovascularSystem = createSubCategory(categoryRepository, "Cardiovascular System",
                    "Models of heart, blood vessels, and circulatory system", null ,anatomyCategory);
            Category digestiveSystem = createSubCategory(categoryRepository, "Digestive System",
                    "Models of stomach, intestines, and other digestive organs",null, anatomyCategory);
            Category nervousSystem = createSubCategory(categoryRepository, "Nervous System",
                    "Models of brain, spinal cord, and neural networks",null, anatomyCategory);
            Category skeletalSystem = createSubCategory(categoryRepository, "Skeletal System",
                    "Models of bones, joints, and skeletal structures", null, anatomyCategory);

            // 2. Geology Category
            Category geologyCategory = categoryRepository.findByName("Geology")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Geology")
                                .description("3D models of geological formations and structures")
                                .image("images-geology-main.jpg")
                                .build();
                        return categoryRepository.save(category);
                    });

            // Geology subcategories
            Category minerals = createSubCategory(categoryRepository, "Minerals",
                    "3D models of various mineral structures and crystals", null, geologyCategory);
            Category tectonics = createSubCategory(categoryRepository, "Plate Tectonics",
                    "Models of tectonic plates and their movements", null, geologyCategory);
            Category volcanology = createSubCategory(categoryRepository, "Volcanology",
                    "Models of volcanic structures and formations", null ,geologyCategory);

            // 3. Chemistry Category
            Category chemistryCategory = categoryRepository.findByName("Chemistry")
                    .orElseGet(() -> {
                        Category category = Category.builder()
                                .name("Chemistry")
                                .description("3D models of molecular structures and chemical compounds")
                                .image("images-chemistry-main.jpg")
                                .build();
                        return categoryRepository.save(category);
                    });

            // Chemistry subcategories
            Category organicChemistry = createSubCategory(categoryRepository, "Organic Chemistry",
                    "Models of organic compounds and molecules", null, chemistryCategory);
            Category inorganicChemistry = createSubCategory(categoryRepository, "Inorganic Chemistry",
                    "Models of inorganic compounds and crystal structures", null ,chemistryCategory);

            // Create Professors
            // Anatomy Professors
            createProfessor(authenticationService, userRepository, "ahmad.khalil@example.com", "Ahmad", "Khalil", anatomyCategory);
            createProfessor(authenticationService, userRepository, "fatima.hassan@example.com", "Fatima", "Hassan", anatomyCategory);
            createProfessor(authenticationService, userRepository, "omar.qasim@example.com", "Omar", "Qasim", anatomyCategory);

            // Geology Professors
            createProfessor(authenticationService, userRepository, "zainab.malik@example.com", "Zainab", "Malik", geologyCategory);
            createProfessor(authenticationService, userRepository, "karim.abdallah@example.com", "Karim", "Abdallah", geologyCategory);
            createProfessor(authenticationService, userRepository, "leila.rahman@example.com", "Leila", "Rahman", geologyCategory);

            // Chemistry Professors
            createProfessor(authenticationService, userRepository, "mustafa.saeed@example.com", "Mustafa", "Saeed", chemistryCategory);
            createProfessor(authenticationService, userRepository, "amira.wahab@example.com", "Amira", "Wahab", chemistryCategory);
            createProfessor(authenticationService, userRepository, "yasir.hamdi@example.com", "Yasir", "Hamdi", chemistryCategory);

            // Create Students with Arabic names
            createStudent(authenticationService, userRepository, "mahmoud.ali@student.com", "Mahmoud", "Ali");
            createStudent(authenticationService, userRepository, "rania.omar@student.com", "Rania", "Omar");
            createStudent(authenticationService, userRepository, "ibrahim.hassan@student.com", "Ibrahim", "Hassan");
            createStudent(authenticationService, userRepository, "layla.mohamed@student.com", "Layla", "Mohamed");
            createStudent(authenticationService, userRepository, "tariq.ahmad@student.com", "Tariq", "Ahmad");
            createStudent(authenticationService, userRepository, "noor.kareem@student.com", "Noor", "Kareem");
            createStudent(authenticationService, userRepository, "zaid.mansour@student.com", "Zaid", "Mansour");
            createStudent(authenticationService, userRepository, "hana.bashir@student.com", "Hana", "Bashir");
            createStudent(authenticationService, userRepository, "yasser.salim@student.com", "Yasser", "Salim");
            createStudent(authenticationService, userRepository, "dina.farid@student.com", "Dina", "Farid");

            // Create 3D Objects for each category
            // Anatomy Objects
            Professor anatomyProf = professorRepository.findByEmail("ahmad.khalil@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Heart Model", "Detailed 3D model of the human heart",
                    "heart.glb", "heart.jpg", cardiovascularSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Brain Model", "Detailed 3D model of the human brain",
                    "brain.glb", "brain.jpg", nervousSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Skeletal System", "Complete human skeletal system",
                    "skeleton.glb", "skeleton.jpg", skeletalSystem, anatomyProf);

            // Geology Objects
            Professor geologyProf = professorRepository.findByEmail("zainab.malik@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Quartz Crystal", "3D model of quartz crystal structure",
                    "quartz.glb", "quartz.jpg", minerals, geologyProf);
            create3DObject(threeDObjectRepository, "Volcano Formation", "Cross-section of a volcanic structure",
                    "volcano.glb", "volcano.jpg", volcanology, geologyProf);
            create3DObject(threeDObjectRepository, "Tectonic Plates", "Interactive model of tectonic plates",
                    "tectonics.glb", "tectonics.jpg", tectonics, geologyProf);

            // Chemistry Objects
            Professor chemistryProf = professorRepository.findByEmail("mustafa.saeed@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Benzene Ring", "3D model of benzene molecular structure",
                    "benzene.glb", "benzene.jpg", organicChemistry, chemistryProf);
            create3DObject(threeDObjectRepository, "NaCl Crystal Structure", "Sodium chloride crystal lattice",
                    "nacl.glb", "nacl.jpg", inorganicChemistry, chemistryProf);
        };
    }

    // Helper methods
    private Category createSubCategory(CategoryRepository repo, String name, String description, String image, Category parent) {
        return repo.findByName(name)
                .orElseGet(() -> {
                    Category category = Category.builder()
                            .name(name)
                            .description(description)
                            .image("images-" + image)
                            .parentCategory(parent)
                            .build();
                    return repo.save(category);
                });
    }

    private void createProfessor(AuthenticationService auth, UserRepository repo, String email,
                                 String firstName, String lastName, Category category) {
        if (!repo.existsByEmail(email)) {
            RegisterUserDTO prof = new RegisterUserDTO();
            prof.setEmail(email);
            prof.setFirstName(firstName);
            prof.setLastName(lastName);
            prof.setPassword("123456");
            prof.setCategory(category);
            prof.setRole("PROF");
            auth.signup(prof);
            System.out.println("Professor " + firstName + " " + lastName + " created.");
        }
    }

    private void createStudent(AuthenticationService auth, UserRepository repo, String email,
                               String firstName, String lastName) {
        if (!repo.existsByEmail(email)) {
            RegisterUserDTO student = new RegisterUserDTO();
            student.setEmail(email);
            student.setFirstName(firstName);
            student.setLastName(lastName);
            student.setPassword("123456");
            student.setRole("STUD");
            auth.signup(student);
            System.out.println("Student " + firstName + " " + lastName + " created.");
        }
    }

    private void create3DObject(ThreeDObjectRepository repo, String name, String description,
                                String objectFile, String imageFile, Category category, Professor professor) {
        repo.findByName(name)
                .orElseGet(() -> {
                    ThreeDObject object = ThreeDObject.builder()
                            .name(name)
                            .description(description)
                            .object("objects-" + objectFile)
                            .image("images-" + imageFile)
                            .category(category)
                            .professor(professor)
                            .build();
                    return repo.save(object);
                });
    }

}

