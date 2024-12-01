import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6D83F2),
      ),
    );
    

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: const Color(0xFF6D83F2),
        shadowColor: Colors.transparent,
        title: const Text(
          'Quiz Challenges',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh, color: Colors.white),
        //     onPressed: _fetchQuizzes,
        //     tooltip: 'Refresh Quizzes',
        //   ),
        // ],
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
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                itemCount: quizzes!.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes![index];
                  return OpenContainer(
                    closedElevation: 0,
                    closedColor: Colors.transparent,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    closedBuilder: (context, action) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 73, 104, 255),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.quiz_outlined,
                            color:  Colors.white,
                          ),
                        ),
                        title: Text(
                          quiz.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
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
                      quizId: quiz.id,
                      quizTitle: quiz.title,
                    ),
                  ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
                },
              ),
            ),
          ),
    );
  }
}