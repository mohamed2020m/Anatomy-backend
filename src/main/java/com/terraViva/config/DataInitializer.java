package com.terraViva.config;

import com.terraViva.dto.RegisterUserDTO;
import com.terraViva.models.*;
import com.terraViva.repositories.*;
import com.terraViva.services.implementations.AuthenticationServiceImpl;
import com.terraViva.services.interfaces.AuthenticationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;

import java.util.List;
import java.util.Map;

@Configuration
@Order(1)
public class DataInitializer {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticationServiceImpl authenticationService;

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Autowired
    private NoteRepository noteRepository;

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
            ThreeDObject tdo_1 = create3DObject(threeDObjectRepository, "Heart Model", "Detailed 3D model of the human heart",
                    "heart.glb", "heart.jpg", cardiovascularSystem, anatomyProf);
            ThreeDObject tdo_2 = create3DObject(threeDObjectRepository, "Brain Model", "Detailed 3D model of the human brain",
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
            ThreeDObject tdo_3 = create3DObject(threeDObjectRepository, "Glucose Molecule", "3D structure of glucose",
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

            // create notes
            createNote("Detailed notes on the anatomy of the human heart.", tdo_1, student10);
            createNote("Comprehensive notes on the functions of different brain regions.", tdo_2, student10);
            createNote("Notes on various types of chemical bonds and their properties.", tdo_3, student09);

            // create quizzes
            createQuizzes();
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

    private ThreeDObject create3DObject(ThreeDObjectRepository repo, String name, String description,
                                String objectFile, String imageFile, Category category, Professor professor) {
        return repo.findByName(name)
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

    private void createNote(String content, ThreeDObject threeDObject, Student student) {
        Note note = Note.builder()
                .content(content)
                .threeDObject(threeDObject)
                .student(student)
                .build();
        noteRepository.save(note);
    }
    public void createQuizzes() {

        // Find subcategories for association
        Category cardiovascularSystem = categoryRepository.findByName("Cardiovascular System")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Cardiovascular System' not found"));
        Category digestiveSystem = categoryRepository.findByName("Digestive System")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Digestive System' not found"));
        Category organicChemistry = categoryRepository.findByName("Organic Chemistry")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Organic Chemistry' not found"));
        Category inorganicChemistry = categoryRepository.findByName("Inorganic Chemistry")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Inorganic Chemistry' not found"));
        Category respiratorySystem = categoryRepository.findByName("Respiratory System")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Respiratory System' not found"));
        Category nervousSystem = categoryRepository.findByName("Nervous System")
                .orElseThrow(() -> new RuntimeException("Subcategory 'Nervous System' not found"));

        // Cardiovascular System Quiz
        Quiz cardiovascularQuiz = new Quiz();
        cardiovascularQuiz.setTitle("Cardiovascular System Comprehensive");
        cardiovascularQuiz.setDescription("Detailed quiz on heart anatomy, blood circulation, and cardiovascular functions.");
        cardiovascularQuiz.setSubCategory(cardiovascularSystem);

        MCQQuestion cardioQuestion1 = new MCQQuestion();
        cardioQuestion1.setQuestionText("What is the primary function of the heart?");
        cardioQuestion1.setOptions(Map.of(
                "A", "To filter blood",
                "B", "To pump blood",
                "C", "To digest food",
                "D", "To regulate hormones"
        ));
        cardioQuestion1.setCorrectAnswer("B");
        cardioQuestion1.setExplanation("The heart pumps blood through the body, supplying oxygen and nutrients.");
        cardioQuestion1.setQuiz(cardiovascularQuiz);

        MCQQuestion cardioQuestion2 = new MCQQuestion();
        cardioQuestion2.setQuestionText("How many chambers does the human heart have?");
        cardioQuestion2.setOptions(Map.of(
                "A", "2",
                "B", "3",
                "C", "4",
                "D", "5"
        ));
        cardioQuestion2.setCorrectAnswer("C");
        cardioQuestion2.setExplanation("The human heart has four chambers: two atria and two ventricles.");
        cardioQuestion2.setQuiz(cardiovascularQuiz);

        MCQQuestion cardioQuestion3 = new MCQQuestion();
        cardioQuestion3.setQuestionText("Which blood vessel carries oxygenated blood from the lungs to the heart?");
        cardioQuestion3.setOptions(Map.of(
                "A", "Aorta",
                "B", "Pulmonary artery",
                "C", "Pulmonary vein",
                "D", "Vena cava"
        ));
        cardioQuestion3.setCorrectAnswer("C");
        cardioQuestion3.setExplanation("Pulmonary veins carry oxygenated blood from the lungs to the left atrium of the heart.");
        cardioQuestion3.setQuiz(cardiovascularQuiz);

        // Digestive System Quiz
        Quiz digestiveQuiz = new Quiz();
        digestiveQuiz.setTitle("Digestive System Exploration");
        digestiveQuiz.setDescription("Comprehensive quiz covering digestive system anatomy and functions.");
        digestiveQuiz.setSubCategory(digestiveSystem);

        MCQQuestion digestiveQuestion1 = new MCQQuestion();
        digestiveQuestion1.setQuestionText("Which organ is responsible for producing bile?");
        digestiveQuestion1.setOptions(Map.of(
                "A", "Stomach",
                "B", "Liver",
                "C", "Pancreas",
                "D", "Gallbladder"
        ));
        digestiveQuestion1.setCorrectAnswer("B");
        digestiveQuestion1.setExplanation("The liver produces bile, which helps in digestion.");
        digestiveQuestion1.setQuiz(digestiveQuiz);

        MCQQuestion digestiveQuestion2 = new MCQQuestion();
        digestiveQuestion2.setQuestionText("What is the primary function of the small intestine?");
        digestiveQuestion2.setOptions(Map.of(
                "A", "Water absorption",
                "B", "Nutrient absorption",
                "C", "Waste storage",
                "D", "Enzyme production"
        ));
        digestiveQuestion2.setCorrectAnswer("B");
        digestiveQuestion2.setExplanation("The small intestine is primarily responsible for nutrient absorption.");
        digestiveQuestion2.setQuiz(digestiveQuiz);

        MCQQuestion digestiveQuestion3 = new MCQQuestion();
        digestiveQuestion3.setQuestionText("Which enzyme begins protein digestion in the stomach?");
        digestiveQuestion3.setOptions(Map.of(
                "A", "Lipase",
                "B", "Amylase",
                "C", "Pepsin",
                "D", "Maltase"
        ));
        digestiveQuestion3.setCorrectAnswer("C");
        digestiveQuestion3.setExplanation("Pepsin is the enzyme that begins protein digestion in the stomach.");
        digestiveQuestion3.setQuiz(digestiveQuiz);

        // Organic Chemistry Quiz
        Quiz organicChemistryQuiz = new Quiz();
        organicChemistryQuiz.setTitle("Organic Chemistry Fundamentals");
        organicChemistryQuiz.setDescription("Detailed quiz on organic chemistry concepts and molecular structures.");
        organicChemistryQuiz.setSubCategory(organicChemistry);

        MCQQuestion organicQuestion1 = new MCQQuestion();
        organicQuestion1.setQuestionText("Which functional group is present in alcohols?");
        organicQuestion1.setOptions(Map.of(
                "A", "-COOH",
                "B", "-OH",
                "C", "-NH2",
                "D", "-SH"
        ));
        organicQuestion1.setCorrectAnswer("B");
        organicQuestion1.setExplanation("The -OH group is characteristic of alcohols.");
        organicQuestion1.setQuiz(organicChemistryQuiz);

        MCQQuestion organicQuestion2 = new MCQQuestion();
        organicQuestion2.setQuestionText("What is the general formula for alkanes?");
        organicQuestion2.setOptions(Map.of(
                "A", "CnH2n",
                "B", "CnH2n+2",
                "C", "CnH2n-2",
                "D", "CnH2n+1"
        ));
        organicQuestion2.setCorrectAnswer("B");
        organicQuestion2.setExplanation("Alkanes follow the general formula CnH2n+2, where n is the number of carbon atoms.");
        organicQuestion2.setQuiz(organicChemistryQuiz);

        MCQQuestion organicQuestion3 = new MCQQuestion();
        organicQuestion3.setQuestionText("Which type of isomerism involves different structural arrangements?");
        organicQuestion3.setOptions(Map.of(
                "A", "Geometric isomerism",
                "B", "Stereoisomerism",
                "C", "Structural isomerism",
                "D", "Optical isomerism"
        ));
        organicQuestion3.setCorrectAnswer("C");
        organicQuestion3.setExplanation("Structural isomerism involves different arrangements of atoms in a molecule.");
        organicQuestion3.setQuiz(organicChemistryQuiz);

        // Inorganic Chemistry Quiz
        Quiz inorganicChemistryQuiz = new Quiz();
        inorganicChemistryQuiz.setTitle("Inorganic Chemistry Complex Structures");
        inorganicChemistryQuiz.setDescription("Advanced quiz on inorganic chemistry molecular structures and bonding.");
        inorganicChemistryQuiz.setSubCategory(inorganicChemistry);

        MCQQuestion inorganicQuestion1 = new MCQQuestion();
        inorganicQuestion1.setQuestionText("What is the coordination number of a central atom in an octahedral complex?");
        inorganicQuestion1.setOptions(Map.of(
                "A", "4",
                "B", "6",
                "C", "8",
                "D", "12"
        ));
        inorganicQuestion1.setCorrectAnswer("B");
        inorganicQuestion1.setExplanation("In an octahedral complex, the central atom is surrounded by 6 ligands.");
        inorganicQuestion1.setQuiz(inorganicChemistryQuiz);

        MCQQuestion inorganicQuestion2 = new MCQQuestion();
        inorganicQuestion2.setQuestionText("Which type of bond is formed between a metal and ligand in coordination compounds?");
        inorganicQuestion2.setOptions(Map.of(
                "A", "Ionic bond",
                "B", "Covalent bond",
                "C", "Coordinate covalent bond",
                "D", "Metallic bond"
        ));
        inorganicQuestion2.setCorrectAnswer("C");
        inorganicQuestion2.setExplanation("Coordination compounds involve coordinate covalent bonds between the metal and ligands.");
        inorganicQuestion2.setQuiz(inorganicChemistryQuiz);

        MCQQuestion inorganicQuestion3 = new MCQQuestion();
        inorganicQuestion3.setQuestionText("What is the IUPAC name for [Co(NH3)6]Cl3?");
        inorganicQuestion3.setOptions(Map.of(
                "A", "Hexaamminecobalt(III) chloride",
                "B", "Cobalt hexaammine chloride",
                "C", "Hexamine cobalt chloride",
                "D", "Cobalt(III) hexaammine trichloride"
        ));
        inorganicQuestion3.setCorrectAnswer("A");
        inorganicQuestion3.setExplanation("Hexaamminecobalt(III) chloride is the correct IUPAC name for this coordination compound.");
        inorganicQuestion3.setQuiz(inorganicChemistryQuiz);

        // Respiratory System Quiz
        Quiz respiratoryQuiz = new Quiz();
        respiratoryQuiz.setTitle("Respiratory System Mechanics");
        respiratoryQuiz.setDescription("Comprehensive quiz on lung anatomy and breathing process.");
        respiratoryQuiz.setSubCategory(respiratorySystem);

        MCQQuestion respiratoryQuestion1 = new MCQQuestion();
        respiratoryQuestion1.setQuestionText("What is the primary function of the alveoli?");
        respiratoryQuestion1.setOptions(Map.of(
                "A", "Air filtration",
                "B", "Oxygen exchange",
                "C", "Mucus production",
                "D", "Temperature regulation"
        ));
        respiratoryQuestion1.setCorrectAnswer("B");
        respiratoryQuestion1.setExplanation("Alveoli are responsible for the exchange of oxygen and carbon dioxide between air and blood.");
        respiratoryQuestion1.setQuiz(respiratoryQuiz);

        MCQQuestion respiratoryQuestion2 = new MCQQuestion();
        respiratoryQuestion2.setQuestionText("Which muscle is primarily responsible for breathing?");
        respiratoryQuestion2.setOptions(Map.of(
                "A", "Heart muscle",
                "B", "Intercostal muscles",
                "C", "Diaphragm",
                "D", "Abdominal muscles"
        ));
        respiratoryQuestion2.setCorrectAnswer("C");
        respiratoryQuestion2.setExplanation("The diaphragm is the primary muscle responsible for breathing, contracting and relaxing to change chest cavity volume.");
        respiratoryQuestion2.setQuiz(respiratoryQuiz);

        // Nervous System Quiz
        Quiz nervousSystemQuiz = new Quiz();
        nervousSystemQuiz.setTitle("Nervous System Exploration");
        nervousSystemQuiz.setDescription("Detailed quiz on neural structure and function.");
        nervousSystemQuiz.setSubCategory(nervousSystem);

        MCQQuestion nervousQuestion1 = new MCQQuestion();
        nervousQuestion1.setQuestionText("What is the main component of grey matter in the brain?");
        nervousQuestion1.setOptions(Map.of(
                "A", "Axons",
                "B", "Nerve endings",
                "C", "Neuron cell bodies",
                "D", "Synapses"
        ));
        nervousQuestion1.setCorrectAnswer("C");
        nervousQuestion1.setExplanation("Grey matter is primarily composed of neuron cell bodies.");
        nervousQuestion1.setQuiz(nervousSystemQuiz);

        MCQQuestion nervousQuestion2 = new MCQQuestion();
        nervousQuestion2.setQuestionText("Which part of the brain is responsible for balance and coordination?");
        nervousQuestion2.setOptions(Map.of(
                "A", "Cerebrum",
                "B", "Cerebellum",
                "C", "Brain stem",
                "D", "Hypothalamus"
        ));
        nervousQuestion2.setCorrectAnswer("B");
        nervousQuestion2.setExplanation("The cerebellum is primarily responsible for balance, coordination, and fine motor control.");
        nervousQuestion2.setQuiz(nervousSystemQuiz);

        // Set questions for each quiz
        cardiovascularQuiz.setQuestions(List.of(cardioQuestion1, cardioQuestion2, cardioQuestion3));
        digestiveQuiz.setQuestions(List.of(digestiveQuestion1, digestiveQuestion2, digestiveQuestion3));
        organicChemistryQuiz.setQuestions(List.of(organicQuestion1, organicQuestion2, organicQuestion3));
        inorganicChemistryQuiz.setQuestions(List.of(inorganicQuestion1, inorganicQuestion2, inorganicQuestion3));
        respiratoryQuiz.setQuestions(List.of(respiratoryQuestion1, respiratoryQuestion2));
        nervousSystemQuiz.setQuestions(List.of(nervousQuestion1, nervousQuestion2));

        // Save all quizzes
        quizRepository.save(cardiovascularQuiz);
        quizRepository.save(digestiveQuiz);
        quizRepository.save(organicChemistryQuiz);
        quizRepository.save(inorganicChemistryQuiz);
        quizRepository.save(respiratoryQuiz);
        quizRepository.save(nervousSystemQuiz);
    }
}

