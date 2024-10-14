import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/material.dart';
import 'package:my_app/EntryPoint.dart';
import 'package:my_app/provider/dataCenter.dart';
import 'package:my_app/service/serviceLocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'flashscreen.dart';
import 'loginScreen.dart';

void main() {
  setup();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DataCenter()),
  ], child: const MyApp()));
}

enum LogMode { loggedin, loggedOut, flashscreen }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = const FlutterSecureStorage();
  LogMode logmode = LogMode.flashscreen;
  void getToken() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      setState(() {
        logmode = LogMode.loggedOut;
      });
    } else {
      setState(() {
        logmode = LogMode.loggedin;
      });
    }
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 94, 89, 90)),
          titleTextStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        primaryColor: Color.fromARGB(255, 255, 255, 255),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => logmode == LogMode.flashscreen
            ? FlashScreen()
            : logmode == LogMode.loggedOut
                ? const LoginScreen()
                : const EntryPoint()
        // {
        //   if (logmode == LogMode.loggedOut) {
        //     return const LoginScreen();
        //   } else {
        //     return const MyHomePage();
        //   }
        // }

        // When navigating to the "/second" route, build the SecondScreen widget.
        //'/second': (context) => const SecondScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
