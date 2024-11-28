import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/Question.dart';
import '../../controller/quizController.dart';

// List<Question> testQuestions = [
//   Question(
//     id: 1,
//     questionText: "What is the primary function of the heart?",
//     options: {
//       "A": "To filter blood",
//       "B": "To pump blood",
//       "C": "To digest food",
//       "D": "To regulate hormones"
//     },
//     correctAnswer: "B",
//     explanation: "The heart pumps blood through the body, supplying oxygen and nutrients.",
//   ),
//   Question(
//     id: 2,
//     questionText: "What is the primary function of the heart?",
//     options: {
//       "A": "To filter blood",
//       "B": "To pump blood",
//       "C": "To digest food",
//       "D": "To regulate hormones"
//     },
//     correctAnswer: "B",
//     explanation: "The heart pumps blood through the body, supplying oxygen and nutrients.",
//   ),
//   // Static questions for testing
// ];

class QuizDetailScreen extends StatefulWidget {
  final String quizId;

  const QuizDetailScreen({super.key, required this.quizId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> with SingleTickerProviderStateMixin {
  final QuizController quizController = QuizController();
  List<Question>? questions;
  String? errorMessage;
  int currentQuestionIndex = 0;
  int score = 0;
  String? selectedAnswer;
  String? explanation;
  bool isAnswered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    try {
      final fetchQuestions = await quizController.getQuestionsOfQuiz(widget.quizId);
      setState(() {
        questions = fetchQuestions;
      });
      //print("questions: $questions");
      //print("Quiz ID : ");
      //print(widget.quizId);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void _nextQuestion() {
    if (questions != null && currentQuestionIndex < questions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        explanation = null;
        isAnswered = false;
        _animationController.forward(from: 0);
      });
    }
  }

  void _submitAnswer() {
    if (questions != null && selectedAnswer != null) {
      if (selectedAnswer == questions![currentQuestionIndex].correctAnswer) {
        setState(() {
          score++;
        });
      }
      setState(() {
        explanation = questions![currentQuestionIndex].explanation;
        isAnswered = true;
      });
    }
  }

  Future<void> _submitQuiz() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                score > questions!.length / 2 
                  ? Icons.sentiment_very_satisfied 
                  : Icons.sentiment_dissatisfied,
                color: score > questions!.length / 2 
                  ? Colors.green 
                  : Colors.red,
              ),
              const SizedBox(width: 10),
              Text('Quiz Completed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your score is: $score/${questions!.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: score > questions!.length / 2 
                    ? Colors.green.shade700 
                    : Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: score / questions!.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  score > questions!.length / 2 
                    ? Colors.green 
                    : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    // Send the score to the server after showing the dialog
    try {
      await quizController.saveScoreOfQuiz(widget.quizId, score.toDouble());
      print("Score submitted successfully.");
    } catch (e) {
      print("Failed to submit score: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions == null || questions!.isEmpty) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Challenge")),
      body: Center(child: Text(errorMessage ?? "No questions available")),
    );
  }
    final currentQuestion = questions![currentQuestionIndex];
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Challenge',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView( // Added to make the content scrollable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Indicator
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: (currentQuestionIndex + 1) / questions!.length),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              );
            },
          ),
          const SizedBox(height: 16),

          // Question Text
          Text(
            'Question ${currentQuestionIndex + 1}/${questions!.length}',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            currentQuestion.questionText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 16),

          // Answer Options
          ...currentQuestion.options.entries.map(
            (entry) {
              Color? cardColor;
              IconData? iconData;
              if (isAnswered) {
                if (entry.key == currentQuestion.correctAnswer) {
                  cardColor = Colors.green.shade100;
                  iconData = Icons.check_circle_outline;
                } else if (entry.key == selectedAnswer && entry.key != currentQuestion.correctAnswer) {
                  cardColor = Colors.red.shade100;
                  iconData = Icons.cancel_outlined;
                }
              }

              return Card(
                color: cardColor ?? colorScheme.surfaceVariant,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: iconData != null
                      ? Icon(
                          iconData,
                          color: cardColor == Colors.green.shade100
                              ? Colors.green
                              : Colors.red,
                        )
                      : Radio<String>(
                          value: entry.key,
                          groupValue: selectedAnswer,
                          onChanged: isAnswered
                              ? null
                              : (value) {
                                  setState(() {
                                    selectedAnswer = value;
                                    explanation = null;
                                  });
                                },
                        ),
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
            },
          ),

          // Explanation
          if (explanation != null)
            Card(
              color: Colors.yellow.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        explanation!,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(),

          // Action Buttons
          const SizedBox(height: 16), // Ensures spacing above the buttons
          if (!isAnswered)
            ElevatedButton.icon(
              onPressed: selectedAnswer != null ? _submitAnswer : null,
              icon: const Icon(Icons.send),
              label: const Text('Submit Answer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          else if (currentQuestionIndex < questions!.length - 1)
            ElevatedButton.icon(
              onPressed: _nextQuestion,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next Question'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: _submitQuiz,
              icon: const Icon(Icons.done_all),
              label: const Text('Submit Quiz'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
        ],
      ),
    ),
  ),
),

    );
  }
}