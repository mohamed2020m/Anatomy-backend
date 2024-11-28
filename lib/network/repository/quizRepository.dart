import 'package:TerraViva/models/Question.dart';
import 'package:dio/dio.dart';

import '../../models/Quiz.dart';
import '../dioException.dart';
import '../api/quizApi.dart';

class QuizRepository {
  
  final QuizApi quizApi;
  
  QuizRepository(this.quizApi);
  
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      final response = await quizApi.getQuizApi();
      print("response: $response.data");

      List<Quiz> allQuizzes =
          (response.data as List).map((e) => Quiz.fromJson(e)).toList();

      return allQuizzes;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getAllQuizzes: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<Question>> getQuestionsOfQuiz(String quizId) async {
    try {
      final response = await quizApi.getQuestionsOfQuizApi(quizId);
      print("response: $response.data");

      List<Question> allQuestions =
          (response.data as List).map((e) => Question.fromJson(e)).toList();

      return allQuestions;
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getQuestionsOfQuiz: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }


  Future<void> saveScoreOfQuiz(String quizId, double score) async {
    try {
      final response = await quizApi.saveScoreOfQuiz(quizId, score);
      
      // Check if the response status is 200 (success)
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to save score. Status code: ${response.statusCode}");
      }

    print("Score successfully saved for quizId: $quizId with score: $score");
    
      // ignore: deprecated_member_use
    } on DioError catch (e) {
      print("Error in getQuestionsOfQuiz: $e");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

}
