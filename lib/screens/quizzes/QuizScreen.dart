import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/Quiz.dart';
import '../../controller/quizController.dart';
import './QuizDetailScreen.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  final QuizController quizController = QuizController();
  List<Quiz>? quizzes;
  String? errorMessage;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fetchQuizzes();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final fetchedQuizzes = await quizController.getAllQuizes();
      setState(() {
        quizzes = fetchedQuizzes;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Challenges',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        backgroundColor: colorScheme.primaryContainer,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchQuizzes,
            tooltip: 'Refresh Quizzes',
          ),
        ],
      ),
      body: quizzes == null
          ? Center(
              child: errorMessage != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade300,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $errorMessage',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _fetchQuizzes,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchQuizzes,
              child: ListView.builder(
                itemCount: quizzes!.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes![index];
                  return OpenContainer(
                    closedBuilder: (context, action) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: colorScheme.surfaceVariant,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.quiz_outlined,
                            color: colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          quiz.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        subtitle: Text(
                          quiz.description,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: colorScheme.secondary,
                          size: 18,
                        ),
                      ),
                    ),
                    openBuilder: (context, action) => QuizDetailScreen(
                      quizId: quiz.id
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
                },
              ),
            ),
    );
  }
}