package com.terraViva.config;

import com.terraViva.models.Category;
import com.terraViva.models.MCQQuestion;
import com.terraViva.models.Quiz;
import com.terraViva.repositories.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;

import java.util.List;
import java.util.Map;

@Configuration
// To ensure that categories are being inserted into DB
//@Order(Ordered.LOWEST_PRECEDENCE)
@Order(50)
public class QuizDataInitializer {

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private CategoryRepository categoryRepository;


    @Bean
    public CommandLineRunner initializeQuiz() {
        return args -> {


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
        };
    }
}

