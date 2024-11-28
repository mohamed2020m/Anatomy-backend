import 'package:TerraViva/models/Question.dart';

import '../models/Quiz.dart';
import '../network/repository/quizRepository.dart';
import '../service/serviceLocator.dart';

class QuizController {

  final userRepository = getIt.get<QuizRepository>();

  Future<List<Quiz>> getAllQuizes() async {
    final allquizes = await userRepository.getAllQuizzes();
    print("allquizes: $allquizes");
    return allquizes;
  }

  Future<List<Question>> getQuestionsOfQuiz(String quizId) async {
    final allQuestions= await userRepository.getQuestionsOfQuiz(quizId);
    print("getQuestionsOfQuiz: $allQuestions");
    return allQuestions;
  }

  Future<void> saveScoreOfQuiz(String quizId, double score) async {
    await userRepository.saveScoreOfQuiz(quizId, score);
  }

}
