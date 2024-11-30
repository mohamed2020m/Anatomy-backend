import 'package:TerraViva/models/Question.dart';

import '../models/Quiz.dart';
import '../network/repository/quizRepository.dart';
import '../service/serviceLocator.dart';

class QuizController {

  final quizRepository = getIt.get<QuizRepository>();

  Future<List<Quiz>> getAllQuizes() async {
    final allquizes = await quizRepository.getAllQuizzes();
    print("allquizes: $allquizes");
    return allquizes;
  }

  Future<List<Question>> getQuestionsOfQuiz(String quizId) async {
    final allQuestions= await quizRepository.getQuestionsOfQuiz(quizId);
    print("getQuestionsOfQuiz: $allQuestions");
    return allQuestions;
  }

  Future<void> saveScoreOfQuiz(String quizId, double score) async {
    await quizRepository.saveScoreOfQuiz(quizId, score);
  }

}
