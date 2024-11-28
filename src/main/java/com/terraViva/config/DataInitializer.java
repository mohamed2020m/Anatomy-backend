package com.terraViva.config;

import com.terraViva.dto.RegisterUserDTO;
import com.terraViva.models.Category;
import com.terraViva.models.Professor;
import com.terraViva.models.Student;
import com.terraViva.models.ThreeDObject;
import com.terraViva.repositories.*;
import com.terraViva.services.implementations.AuthenticationServiceImpl;
import com.terraViva.services.interfaces.AuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;

@Configuration
@Order(1)
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
                    "Models of heart, blood vessels, and circulatory system", "cardiovascular-system.jpg" ,anatomyCategory);
            Category digestiveSystem = createSubCategory(categoryRepository, "Digestive System",
                    "Models of stomach, intestines, and other digestive organs","digestive-system.jpg", anatomyCategory);
            Category nervousSystem = createSubCategory(categoryRepository, "Nervous System",
                    "Models of brain, spinal cord, and neural networks","nervous-system.jpg", anatomyCategory);
            Category skeletalSystem = createSubCategory(categoryRepository, "Skeletal System",
                    "Models of bones, joints, and skeletal structures", "skeletal-system.jpg", anatomyCategory);
            Category respiratorySystem = createSubCategory(categoryRepository, "Respiratory System",
                    "Models of lung, joints, and skeletal structures", "respiratory-system.jpg", anatomyCategory);

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
            Category earthScience = createSubCategory(categoryRepository, "Earth Science",
                    "Models of earth structures and formations", null ,geologyCategory);

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
            Category biochemistry = createSubCategory(categoryRepository, "Biochemistry",
                    "Models of biochemistry compounds and  structures", null ,chemistryCategory);

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

            // Create Students
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

            // Create 3D Objects for each sub-category
            // Anatomy Objects
            Professor anatomyProf = professorRepository.findByEmail("ahmad.khalil@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Heart Model", "Detailed 3D model of the human heart",
                    "heart.glb", "heart.jpg", cardiovascularSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Brain Model", "Detailed 3D model of the human brain",
                    "brain.glb", "brain.jpg", nervousSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Skeletal System", "Complete human skeletal system",
                    "skeleton.glb", "skeleton.jpg", skeletalSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Lung Model", "Detailed 3D model of the human lung",
                    "Lung.glb", "lung.jpg", skeletalSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Eye Model", "Detailed 3D model of the human eye",
                    "eye.glb", "eye.jpg", skeletalSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Large Intestine", "Detailed 3D model of the human large intestine",
                    "large-intestine.glb", "large-intestine.jpg", skeletalSystem, anatomyProf);
            create3DObject(threeDObjectRepository, "Kidney", "Detailed 3D model of the human kidney",
                    "kidney.glb", "kidney.jpg", skeletalSystem, anatomyProf);


            // Geology Objects
            Professor geologyProf = professorRepository.findByEmail("zainab.malik@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Quartz Crystal", "3D model of quartz crystal structure",
                    "quartz.glb", "quartz.jpg", minerals, geologyProf);
            create3DObject(threeDObjectRepository, "Volcano Formation", "Cross-section of a volcanic structure",
                    "volcano.glb", "volcano.jpg", volcanology, geologyProf);
            create3DObject(threeDObjectRepository, "Tectonic Plates", "Interactive model of tectonic plates",
                    "tectonics.glb", "tectonics.jpg", tectonics, geologyProf);
            create3DObject(threeDObjectRepository, "Earth Layers", "Cross-section of Earth's internal structure",
                    "earth-layers.glb", "earth-layers.jpg", earthScience, geologyProf);
            create3DObject(threeDObjectRepository, "Earth", "3D model of earth structure",
                    "earth.glb", "earth.jpg", earthScience, geologyProf);

            // Chemistry Objects
            Professor chemistryProf = professorRepository.findByEmail("mustafa.saeed@example.com").orElseThrow();
            create3DObject(threeDObjectRepository, "Benzene Ring", "3D model of benzene molecular structure",
                    "benzene.glb", "benzene.jpg", organicChemistry, chemistryProf);
            create3DObject(threeDObjectRepository, "NaCl Crystal Structure", "Sodium chloride crystal lattice",
                    "nacl.glb", "nacl.jpg", inorganicChemistry, chemistryProf);
            create3DObject(threeDObjectRepository, "DNA Double Helix", "3D model of DNA structure",
                    "dna.glb", "dna.jpg", biochemistry, chemistryProf);
            create3DObject(threeDObjectRepository, "Ethanol Structure", "3D model of ethanol molecule",
                    "ethanol.glb", "ethanol.jpg", organicChemistry, chemistryProf);
            create3DObject(threeDObjectRepository, "Glucose Molecule", "3D structure of glucose",
                    "glucose.glb", "glucose.jpg", organicChemistry, chemistryProf);

            // Assign Students to Sub-Categories
            Student student01 = studentRepository.findByEmail("mahmoud.ali@student.com").orElseThrow();
            student01.getCategories().add(anatomyCategory);
            student01.getCategories().add(cardiovascularSystem);
            student01.getCategories().add(geologyCategory);

            Student student02 = studentRepository.findByEmail("rania.omar@student.com").orElseThrow();
            student02.getCategories().add(anatomyCategory);
            student02.getCategories().add(digestiveSystem);
            student02.getCategories().add(geologyCategory);

            Student student03 = studentRepository.findByEmail("ibrahim.hassan@student.com").orElseThrow();
            student03.getCategories().add(anatomyCategory);
            student03.getCategories().add(nervousSystem);
            student03.getCategories().add(geologyCategory);

            Student student04 = studentRepository.findByEmail("layla.mohamed@student.com").orElseThrow();
            student04.getCategories().add(anatomyCategory);
            student04.getCategories().add(skeletalSystem);
            student04.getCategories().add(geologyCategory);

            Student student05 = studentRepository.findByEmail("tariq.ahmad@student.com").orElseThrow();
            student05.getCategories().add(anatomyCategory);
            student05.getCategories().add(skeletalSystem);
            student05.getCategories().add(geologyCategory);

            Student student06 = studentRepository.findByEmail("noor.kareem@student.com").orElseThrow();
            student06.getCategories().add(anatomyCategory);
            student06.getCategories().add(skeletalSystem);
            student06.getCategories().add(geologyCategory);

            Student student07 = studentRepository.findByEmail("zaid.mansour@student.com").orElseThrow();
            student07.getCategories().add(anatomyCategory);
            student07.getCategories().add(skeletalSystem);
            student07.getCategories().add(geologyCategory);

            Student student08 = studentRepository.findByEmail("hana.bashir@student.com").orElseThrow();
            student08.getCategories().add(chemistryCategory);
            student08.getCategories().add(volcanology);
            student08.getCategories().add(geologyCategory);
            student08.getCategories().add(skeletalSystem);

            Student student09 = studentRepository.findByEmail("yasser.salim@student.com").orElseThrow();
            student09.getCategories().add(chemistryCategory);
            student09.getCategories().add(tectonics);
            student09.getCategories().add(skeletalSystem);
            student08.getCategories().add(geologyCategory);

            Student student10 = studentRepository.findByEmail("dina.farid@student.com").orElseThrow();
            student10.getCategories().add(chemistryCategory);
            student10.getCategories().add(nervousSystem);
            student10.getCategories().add(geologyCategory);

            studentRepository.save(student01);
            studentRepository.save(student02);
            studentRepository.save(student03);
            studentRepository.save(student04);
            studentRepository.save(student05);
            studentRepository.save(student06);
            studentRepository.save(student07);
            studentRepository.save(student08);
            studentRepository.save(student09);
            studentRepository.save(student10);


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

