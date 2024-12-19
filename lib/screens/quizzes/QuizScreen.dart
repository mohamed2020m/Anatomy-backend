import 'package:TerraViva/models/StudentScores.dart';
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

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final QuizController quizController = QuizController();
  List<Quiz>? quizzes;
  List<StudentScores>? scores;
  String? errorMessage;
  late AnimationController _animationController;
  bool isResetting = false;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fetchQuizzes();
    _fetchScores();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuizzes() async {
    print("Fetching quizzes...");
    try {
      final fetchedQuizzes = await quizController.getAllQuizes();
      setState(() {
        quizzes = fetchedQuizzes;
      });
      _fetchScores();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _fetchScores() async {
    // print("Fetching scores...");
    try {
      final fetchedScores = await quizController.getScoresOfAllQuizzes();
      setState(() {
        scores = fetchedScores;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  bool shouldShowRetryButton(String quizId) {
    final parsedQuizId = int.tryParse(quizId);
    if (parsedQuizId == null) return false;
    return scores?.any((score) => score.quizId == parsedQuizId) ?? false;
  }

  // Reset Quiz Function
  // Future<void> _resetQuiz(String quizId) async {
  //   try {
  //     await quizController.resetQuiz(quizId);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Quiz has been reset!')),
  //     );
  //     // refresh quizzes
  //     _fetchQuizzes();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   }
  // }

  // Future<void> _resetQuiz(String quizId) async {
  //   try {
  //     // Start animation
  //     _animationController.forward(from: 0);
  //     await Future.delayed(
  //         const Duration(milliseconds: 500)); // Animation delay

  //     await quizController.resetQuiz(quizId);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Quiz has been reset!')),
  //     );
  //     // Refresh quizzes
  //     _fetchQuizzes();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   }
  // }

  Future<void> _resetQuiz(String quizId) async {
    if (isResetting) return; // Prevent multiple clicks during animation
    setState(() {
      isResetting = true;
    });

    try {
      // Start animation
      _animationController.forward(from: 0);
      await Future.delayed(
          const Duration(milliseconds: 500)); // Animation delay

      await quizController.resetQuiz(quizId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz has been reset!')),
      );
      // Refresh quizzes
      await _fetchQuizzes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isResetting = false;
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
          style: TextStyle(
              fontWeight: FontWeight.w900, fontSize: 20, color: Colors.white),
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
                    final showRetry = shouldShowRetryButton(quiz.id);

                    return GestureDetector(
                      onTap: isResetting
                          ? null
                          : () => {}, // Disable taps during reset
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: showRetry
                                ? 1 - (_animationController.value * 0.2)
                                : 1.0,
                            child: Opacity(
                              opacity: showRetry
                                  ? 1 - _animationController.value
                                  : 1.0,
                              child: OpenContainer(
                                closedElevation: 0,
                                closedColor: Colors.transparent,
                                openElevation: 0,
                                openColor: Colors.transparent,
                                closedBuilder: (context, action) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  color: showRetry
                                      ? Colors
                                          .grey.shade300 // Grayed background
                                      : Colors
                                          .white, // Default background color
                                  child: Stack(
                                    children: [
                                      ListTile(
                                        contentPadding:
                                            const EdgeInsets.all(12),
                                        leading: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 73, 104, 255),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.quiz_outlined,
                                            color: Colors.white,
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
                                            color: colorScheme.onSurfaceVariant
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                        trailing: !showRetry
                                            ? Icon(
                                                Icons.arrow_forward_ios,
                                                color: colorScheme.secondary,
                                                size: 18,
                                              )
                                            : null,
                                      ),
                                      if (showRetry)
                                        Positioned.fill(
                                          child: Center(
                                            child: ElevatedButton.icon(
                                              onPressed: isResetting
                                                  ? null
                                                  : () => _resetQuiz(quiz.id),
                                              icon: const Icon(
                                                Icons.refresh,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                "Retry",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                openBuilder: (context, action) =>
                                    QuizDetailScreen(
                                  quizId: quiz.id,
                                  quizTitle: quiz.title,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );

                    // return AnimatedBuilder(
                    //   animation: _animationController,
                    //   builder: (context, child) {
                    //     return Transform.scale(
                    //       scale: showRetry
                    //           ? 1 - (_animationController.value * 0.2)
                    //           : 1.0,
                    //       child: Opacity(
                    //         opacity: showRetry
                    //             ? 1 - _animationController.value
                    //             : 1.0,
                    //         child: OpenContainer(
                    //           closedElevation: 0,
                    //           closedColor: Colors.transparent,
                    //           openElevation: 0,
                    //           openColor: Colors.transparent,
                    //           closedBuilder: (context, action) => Card(
                    //             margin: const EdgeInsets.symmetric(
                    //                 horizontal: 16, vertical: 8),
                    //             elevation: 4,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             color: showRetry
                    //                 ? Colors.grey.shade300 // Grayed background
                    //                 : Colors.white, // Default background color
                    //             child: Stack(
                    //               children: [
                    //                 ListTile(
                    //                   contentPadding: const EdgeInsets.all(12),
                    //                   leading: Container(
                    //                     padding: const EdgeInsets.all(10),
                    //                     decoration: const BoxDecoration(
                    //                       color:
                    //                           Color.fromARGB(255, 73, 104, 255),
                    //                       shape: BoxShape.circle,
                    //                     ),
                    //                     child: const Icon(
                    //                       Icons.quiz_outlined,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                   title: Text(
                    //                     quiz.title,
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w800,
                    //                       color: colorScheme.onSurfaceVariant,
                    //                     ),
                    //                   ),
                    //                   subtitle: Text(
                    //                     quiz.description,
                    //                     style: TextStyle(
                    //                       color: colorScheme.onSurfaceVariant
                    //                           .withOpacity(0.7),
                    //                     ),
                    //                   ),
                    //                   trailing: !showRetry
                    //                       ? Icon(
                    //                           Icons.arrow_forward_ios,
                    //                           color: colorScheme.secondary,
                    //                           size: 18,
                    //                         )
                    //                       : null,
                    //                 ),
                    //                 if (showRetry)
                    //                   Positioned.fill(
                    //                     child: Center(
                    //                       child: ElevatedButton.icon(
                    //                         onPressed: () =>
                    //                             _resetQuiz(quiz.id),
                    //                         icon: const Icon(
                    //                           Icons.refresh,
                    //                           color: Colors.white,
                    //                         ),
                    //                         label: const Text(
                    //                           "Retry",
                    //                           style: TextStyle(
                    //                             fontWeight: FontWeight.w600,
                    //                             color: Colors.white,
                    //                           ),
                    //                         ),
                    //                         style: ElevatedButton.styleFrom(
                    //                           backgroundColor:
                    //                               Colors.transparent,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //               ],
                    //             ),
                    //           ),
                    //           openBuilder: (context, action) =>
                    //               QuizDetailScreen(
                    //             quizId: quiz.id,
                    //             quizTitle: quiz.title,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );
                  },
                ),
              ),
            ),
    );
  }
}
