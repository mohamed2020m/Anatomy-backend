import 'package:TerraViva/models/ThreeDObject.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../controller/categoryController.dart';
import '../controller/threeDObjectController.dart';
import '../controller/quizController.dart';
import '../controller/logOutController.dart';
import '../controller/loginController.dart';
import '../controller/noteController.dart';
import '../controller/objectsParCategoryController.dart';
import '../controller/searchController2.dart';
import '../controller/userDetailController.dart';
import '../network/api/SearchApi.dart';
import '../network/api/categoryApi.dart';
import '../network/api/quizApi.dart';
import '../network/api/threeDObjectApi.dart';
import '../network/api/logOutApi.dart';
import '../network/api/loginApi.dart';
import '../network/api/noteApi.dart';
import '../network/api/objectsParCategoryApi.dart';
import '../network/api/userDetailApi.dart';
import '../network/repository/categoryRepository.dart';
import '../network/repository/quizRepository.dart';
import '../network/dioClient.dart';
import '../network/repository/loginRepository.dart';
import '../network/repository/logoutRepository.dart';
import '../network/repository/noteRepository.dart';
import '../network/repository/threeDObjectRepository.dart';
import '../network/repository/objectsParCategoryRepository.dart';
import '../network/repository/searchRepository.dart';
import '../network/repository/userDetailRepository.dart';

final getIt = GetIt.instance;
Future<void> setup() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));

    // login
  getIt.registerSingleton(LogInApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(LogInRepository(getIt.get<LogInApi>()));
  getIt.registerSingleton(LoginController());
  
  //logout
  // getIt.registerSingleton(LogOutApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(LogOutApi());
  getIt.registerSingleton(LogOutRepository(getIt.get<LogOutApi>()));
  getIt.registerSingleton(LogoutController());

   //user information
  getIt.registerSingleton(UserDetailApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(UserDetailRepository(getIt<UserDetailApi>()));
  getIt.registerSingleton(UserDetailController());

  //category
  getIt.registerSingleton(CategoryApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(CategoryRepository(getIt.get<CategoryApi>()));
  getIt.registerSingleton(CategoryController());

  // Quiz
  getIt.registerSingleton(QuizApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(QuizRepository(getIt.get<QuizApi>()));
  getIt.registerSingleton(QuizController());

  //objects3d
  getIt.registerSingleton(ObjectsParCategoryApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(ObjectsParCategoryRepository(getIt.get<ObjectsParCategoryApi>()));
  getIt.registerSingleton(ObjectsParCategoryController());

  // notes
  getIt.registerSingleton(NoteApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(NoteRepository(getIt.get<NoteApi>()));
  getIt.registerSingleton(NoteController());

  // ThreeDObject
  getIt.registerSingleton(ThreedObjectApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(ThreeDObjectRepository(getIt.get<ThreedObjectApi>()));
  getIt.registerSingleton(ThreeDObjectController());

  // search par category
  getIt.registerSingleton(SearchApi(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(SearchRepository(getIt.get<SearchApi>()));
  getIt.registerSingleton(SearchController2());

}
