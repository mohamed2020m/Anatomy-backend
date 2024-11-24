// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/service/serviceLocator.dart';
// import 'package:my_app/validator.dart';

// import 'EntryPoint.dart';
// import 'controller/loginController.dart';
// import 'createNewUser.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final GlobalKey<FormState> _formForRestPassword = GlobalKey<FormState>();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController emailForRestPasswController =
//       TextEditingController();
//   bool _showPassword = false;
//   bool passwdListner = false;
//   bool emailListner = false;

//   final loginController = getIt<LoginController>();

//   Future<void> login() async {
//     if (_formKey.currentState!.validate()) {
//       showDialog(
//           useRootNavigator: false,
//           barrierDismissible: false,
//           barrierColor: const Color.fromARGB(0, 0, 0, 0),
//           context: context,
//           builder: (BuildContext context) => WillPopScope(
//                 onWillPop: () async => false,
//                 child: Center(
//                     child: Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(90),
//                       color: const Color.fromARGB(36, 81, 86, 90)),
//                   child: const Center(
//                       child: CupertinoActivityIndicator(
//                     radius: 20,
//                   )),
//                 )),
//               ));
//       try {
//         await loginController.login(
//             emailController.text, passwordController.text);

//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const EntryPoint()),
//             (route) => false);
//       } catch (e) {
//         Navigator.pop(context);
//         showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                   buttonPadding: EdgeInsets.zero,
//                   shape: const RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                   contentPadding:
//                       const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
//                   title: const Text(
//                     'La connexion a échoué',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                   ),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: const EdgeInsets.only(
//                             left: 8, right: 8, bottom: 24),
//                         child: Text(
//                           e.toString(),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                               child: InkWell(
//                             borderRadius: const BorderRadius.only(
//                               bottomLeft: Radius.circular(10),
//                             ),
//                             onTap: () => Navigator.pop(context),
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                   border: Border(
//                                 top: BorderSide(color: Colors.grey),
//                               )),
//                               height: 50,
//                               child: const Center(
//                                 child: Text("OK",
//                                     style: TextStyle(
//                                         color: Colors.blue,
//                                         fontWeight: FontWeight.w600)),
//                               ),
//                             ),
//                           ))
//                         ],
//                       )
//                     ],
//                   ),
//                 ));
//         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         //   content: Text('Error: ${e.toString()}'),
//         //   backgroundColor: Colors.red.shade300,
//         // ));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 50,
//           automaticallyImplyLeading: false,
//           shadowColor: Colors.transparent,
//           title: TextButton(
//               style: ButtonStyle(
//                 // minimumSize : MaterialStateProperty.all(Size(0,0)),
//                 overlayColor: WidgetStateProperty.all(Colors.transparent),
//                 splashFactory: NoSplash.splashFactory,
//               ),
//               onPressed: () {
//                 //TODO:
//               },
//               child: const Text(
//                 "Sign up later",
//                 style: TextStyle(color: Colors.indigo, fontSize: 15),
//               )),
//         ),
//         body: Form(
//           key: _formKey,
//           child: Stack(children: [
//             SizedBox(
//               width: size.width,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 padding: const EdgeInsets.symmetric(horizontal: 30),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         SizedBox(height: size.height * 0.04),

//                         Center(
//                           child: Container(
//                             margin: const EdgeInsets.only(
//                               bottom: 8,
//                             ),
//                             width: 128,
//                             child: const Image(
//                                 image: AssetImage("assets/images/logo.png")),
//                           ),
//                         ),
//                         const Center(
//                             child: Text(
//                           "TerraViva",
//                           style: TextStyle(
//                               fontSize: 34,
//                               fontWeight: FontWeight.bold,
//                               color: Color.fromARGB(255, 41, 101, 117)),
//                         )),
//                         // SizedBox(height: size.height * 0.08),

//                         SizedBox(height: size.height * 0.01),
//                         const Center(
//                           child: Text(
//                             "Log in to your account",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.height * 0.06),
//                         TextFormField(
//                           onChanged: ((value) {
//                             if (value.isNotEmpty) {
//                               setState(() {
//                                 emailListner = true;
//                               });
//                             } else {
//                               setState(() {
//                                 emailListner = false;
//                               });
//                             }
//                           }),
//                           // initialValue: 'yazid.slila01@gmail.com',
//                           controller: emailController,
//                           validator: (value) {
//                             return Validator.validateEmail(value ?? "");
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Email address (required)",
//                             isDense: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.height * 0.02),
//                         TextFormField(
//                           onChanged: ((value) {
//                             if (value.isNotEmpty) {
//                               setState(() {
//                                 passwdListner = true;
//                               });
//                             } else {
//                               setState(() {
//                                 passwdListner = false;
//                               });
//                             }
//                           }),
//                           // initialValue: "y.okg123",
//                           obscureText: _showPassword,
//                           controller: passwordController,
//                           validator: (value) {
//                             return Validator.validatePassword(value ?? "");
//                           },
//                           decoration: InputDecoration(
//                             suffixIcon: GestureDetector(
//                               onTap: () {
//                                 setState(() => _showPassword = !_showPassword);
//                               },
//                               child: Icon(
//                                 _showPassword
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             hintText: "Password (required)",
//                             isDense: true,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.height * 0.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             TextButton(
//                                 style: ButtonStyle(
//                                   minimumSize:
//                                       WidgetStateProperty.all(const Size(0, 0)),
//                                   overlayColor: WidgetStateProperty.all(
//                                       Colors.transparent),
//                                   splashFactory: NoSplash.splashFactory,
//                                 ),
//                                 onPressed: () {},
//                                 child: const Text(
//                                   "Forgot password?",
//                                   style: TextStyle(
//                                       color: Colors.indigo,
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w700),
//                                 )),
//                           ],
//                         ),
//                         SizedBox(height: size.height * 0.02),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: emailListner && passwdListner
//                                     ? login
//                                     : () {},
//                                 style: ElevatedButton.styleFrom(
//                                     shadowColor: Colors.transparent,
//                                     splashFactory: emailListner && passwdListner
//                                         ? InkRipple.splashFactory
//                                         : NoSplash.splashFactory,
//                                     enableFeedback: true,
//                                     backgroundColor: emailListner &&
//                                             passwdListner
//                                         ? Colors.indigo
//                                         : const Color.fromARGB(255, 109, 111, 122),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(5)),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 40, vertical: 15)),
//                                 child: const Text(
//                                   "Log in",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: size.height * 0.04),
//                         // Center(
//                         //   child: TextButton(
//                         //       style: ButtonStyle(
//                         //         overlayColor: WidgetStateProperty.all(
//                         //             Colors.transparent),
//                         //         splashFactory: NoSplash.splashFactory,
//                         //       ),
//                         //       onPressed: () {
//                         //         //TODO:
//                         //         Navigator.push<dynamic>(
//                         //             context,
//                         //             MaterialPageRoute<dynamic>(
//                         //                 builder: (BuildContext context) =>
//                         //                     const CreateUserScreen()));
//                         //       },
//                         //       child: const Text(
//                         //         "Are you new to 3D Anatomy? Create an account",
//                         //         textAlign: TextAlign.center,
//                         //         style: TextStyle(
//                         //             color: Colors.indigo, fontSize: 16),
//                         //       )),
//                         // ),
//                         // SizedBox(height: size.height * 0.09),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//         ));
//   }
// }

import 'package:TerraViva/EntryPoint.dart';
import 'package:TerraViva/controller/loginController.dart';
import 'package:TerraViva/service/serviceLocator.dart';
import 'package:TerraViva/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;

  final loginController = getIt<LoginController>();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          useRootNavigator: false,
          barrierDismissible: false,
          barrierColor: const Color.fromARGB(0, 0, 0, 0),
          context: context,
          builder: (BuildContext context) => WillPopScope(
            onWillPop: () async => false,
            child: Center(
                child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: const Color.fromARGB(36, 81, 86, 90)),
              child: const Center(
                  child: CupertinoActivityIndicator(
                radius: 20,
              )),
            )
          ),
        )
      ); // showDialog
      
      try {
        await loginController.login(emailController.text, passwordController.text);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const EntryPoint()),
          (route) => false
        );
      } catch (e) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            buttonPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding:
                const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
            title: const Text(
              'La connexion a échoué',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      left: 8, right: 8, bottom: 24),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                      ),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          top: BorderSide(color: Colors.grey),
                        )),
                        height: 50,
                        child: const Center(
                          child: Text("OK",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ))
                  ],
                )
              ],
            ),
          )
        );
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('Error: ${e.toString()}'),
        //   backgroundColor: Colors.red.shade300,
        // ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              // Logo
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Log in to your account",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        return Validator.validateEmail(value ?? "");
                      },
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_showPassword,
                      validator: (value) {
                        return Validator.validatePassword(value ?? "");
                      },
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Forgot password logic
                        },
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 63, 81, 181),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Login Button
                    ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        // textStyle: const TextStyle(
                        //   fontSize: 18,
                        //   color: Colors.white,
                        // ),
                        foregroundColor: Colors.white,
                        minimumSize: Size(size.width, 50),
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Or connect using",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Google Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Google Login logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      minimumSize: const Size(140, 50),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(FontAwesomeIcons.google),
                    label: const Text("Google"),
                  ),
                  // Microsoft Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Microsoft Login logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      minimumSize: const Size(140, 50),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(FontAwesomeIcons.microsoft),
                    label: const Text("Microsoft"),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.07),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "TerraViva Team", // App name
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "@2024",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}