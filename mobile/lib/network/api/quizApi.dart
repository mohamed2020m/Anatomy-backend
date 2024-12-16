import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Endpoints.dart';
import '../dioClient.dart';

class QuizApi {
  final DioClient dioClient;
  final storage = const FlutterSecureStorage();
  QuizApi({required this.dioClient});

  Future<Response> getQuizApi() async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      print("Using token: $token");

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.quiz}', //endpoint called
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );

      // print("getQuizApi Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getQuizApi: $e");
      rethrow;
    }
  }

  Future<Response> getQuestionsOfQuizApi(String quizId) async {
    try {
      final token = await storage.read(key: "token");
      if (token == null) {
        throw Exception("Token is missing");
      }
      print("Using token: $token");

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.question}/quiz/$quizId', //endpoint called
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );

      print("getQuestionsApi Response: ${response.data}");
      return response;
    } catch (e) {
      print("Error in getQuestionsApi: $e");
      rethrow;
    }
  }


  Future<Response> saveScoreOfQuiz(String quizId, double score) async { 
      try {
        final token = await storage.read(key: "token");
        final userId = await storage.read(key: "user_id");
        if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
        }
        print("Using token: $token");
        print("Using userId: $userId");

        final body = {                  
          "studentId": int.parse(userId),
          "quizId": quizId, //int.parse(quizId),
          "score": score        
        };

        final Response response = await dioClient.post(
          '${Endpoints.baseUrl}${Endpoints.score}', //endpoint called
          options: Options(
            headers: {
              "Authorization": 'Bearer $token'
            },
          ),
          data: body,
        );

        print("saveScoreOfQuize Response: ${response.data}");
        return response;
      } catch (e) {
        print("Error in saveScoreOfQuize: $e");
        rethrow;
      }
  }

    Future<void> resetQuiz(String quizId) async { 
      try {
        
        final token = await storage.read(key: "token");
        final userId = await storage.read(key: "user_id");
        
        if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
        }
        //print("Using token: $token");
        //print("Using userId: $userId");

        await dioClient.delete(
          '${Endpoints.baseUrl}${Endpoints.score}/quiz/$quizId/student/$userId', //endpoint called
          options: Options(
            headers: {
              "Authorization": 'Bearer $token'
            },
          ),
        );
        
        // if (response.statusCode == 204) {
        //   print("Quiz successfully reset for quizId: $quizId.");
        // }

      } catch (e) {
        print("Error in resetQuiz: $e");
        rethrow;
      }
  }


  Future<Response> getScoresOfAllQuizzes() async {
    try {
      final token = await storage.read(key: "token");
      final userId = await storage.read(key: "user_id");

      if (token == null || userId == null) {
          throw Exception("Token or User ID is missing");
      }
      
      // print("Using token: $token");
      // print("Using userId: $userId");

      final Response response = await dioClient.get(
        '${Endpoints.baseUrl}${Endpoints.score}', //endpoint called
        options: Options(
          headers: {
            "Authorization": 'Bearer $token'
          },
        ),
      );

      print("getScoresOfAllQuizzes Response: ${response.data}");
      return response;
    
    } catch (e) {
      print("Error in getScoresOfAllQuizzes: $e");
      rethrow;
    }
  }


}
