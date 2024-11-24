import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:TerraViva/service/serviceLocator.dart';
import 'controller/createUserController.dart';
import 'loginScreen.dart';
import 'validator.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool passwdListner = false;
  bool emailListner = false;
  bool firstnameListner = false;
  bool lastnameListner = false;
  final craeteUserController = getIt.get<CreateUserController>();

  Future<void> create() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
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
                )),
              ));
      try {
        dynamic response = await craeteUserController.createuser(
            firstnameController.text,
            lastnameController.text,
            emailController.text,
            passwordController.text);
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 70),
                  buttonPadding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  contentPadding:
                      const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 24),
                        child: const Text(
                          //TODO:
                          "Your account is created successfully.",
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
                            onTap: () {
                              Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          const LoginScreen()));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                top: BorderSide(color: Colors.grey),
                                left: BorderSide(color: Colors.grey),
                              )),
                              height: 50,
                              child: const Center(
                                child: Text("Log in ",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ));
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const MyHomePage()),
        //     (route) => false);
      } catch (e) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 70),
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
                ));
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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          title: TextButton.icon(
            style: ButtonStyle(
              // minimumSize : MaterialStateProperty.all(Size(0,0)),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              //TODO:
              Navigator.pop(context);
            },
            label: const Text(
              "Retour",
              style: TextStyle(color: Colors.indigo, fontSize: 15),
            ),
            icon: const SizedBox(
                width: 10,
                height: 30,
                child:
                    Icon(Icons.arrow_back_ios, size: 18, color: Colors.indigo)),
          ),
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            width: 128,
                            child: const Image(
                                image: AssetImage("assets/images/logo.jpg")),
                          ),
                        ),
                        // SizedBox(height: size.height * 0.08),
                        const Center(
                          child: Text(
                            "3D Anatomy",
                            style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 41, 101, 117)),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        const Center(
                          child: Text(
                            "Create an account",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.06),
                        TextFormField(
                          onChanged: ((value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                lastnameListner = true;
                              });
                            } else {
                              setState(() {
                                lastnameListner = false;
                              });
                            }
                          }),
                          // initialValue: 'yazid.slila01@gmail.com',
                          controller: lastnameController,
                          validator: (value) {
                            return Validator.validateName(value ?? "");
                          },
                          decoration: InputDecoration(
                            hintText: "First name (required)",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          onChanged: ((value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                firstnameListner = true;
                              });
                            } else {
                              setState(() {
                                firstnameListner = false;
                              });
                            }
                          }),
                          // initialValue: 'yazid.slila01@gmail.com',
                          controller: firstnameController,
                          validator: (value) {
                            return Validator.validateName(value ?? "");
                          },
                          decoration: InputDecoration(
                            hintText: "Last name (required)",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          onChanged: ((value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                emailListner = true;
                              });
                            } else {
                              setState(() {
                                emailListner = false;
                              });
                            }
                          }),
                          // initialValue: 'yazid.slila01@gmail.com',
                          controller: emailController,
                          validator: (value) {
                            return Validator.validateEmail(value ?? "");
                          },
                          decoration: InputDecoration(
                            hintText: "Email address (required)",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFormField(
                          onChanged: ((value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                passwdListner = true;
                              });
                            } else {
                              setState(() {
                                passwdListner = false;
                              });
                            }
                          }),
                          // initialValue: "y.okg123",
                          obscureText: _showPassword,
                          controller: passwordController,
                          validator: (value) {
                            return Validator.validatePassword(value ?? "");
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() => _showPassword = !_showPassword);
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: "Password (required)",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        // SizedBox(height: size.height * 0.0),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     TextButton(
                        //         style: ButtonStyle(
                        //           minimumSize:
                        //               MaterialStateProperty.all(Size(0, 0)),
                        //           overlayColor: MaterialStateProperty.all(
                        //               Colors.transparent),
                        //           splashFactory: NoSplash.splashFactory,
                        //         ),
                        //         onPressed: () {},
                        //         child: Text(
                        //           "Mot de passe oublié?",
                        //           style: TextStyle(
                        //               color: Colors.indigo, fontSize: 15),
                        //         )),
                        //   ],
                        // ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: emailListner &&
                                        passwdListner &&
                                        firstnameListner &&
                                        lastnameListner
                                    ? create
                                    : () {},
                                style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    splashFactory: emailListner && passwdListner
                                        ? InkRipple.splashFactory
                                        : NoSplash.splashFactory,
                                    enableFeedback: true,
                                    backgroundColor:
                                        emailListner && passwdListner
                                            ? Colors.indigo
                                            : Colors.indigo,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15)),
                                child: const Text(
                                  "Create an account",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.06),
                        // SizedBox(height: size.height * 0.04),
                        // Center(
                        //   child: TextButton(
                        //       style: ButtonStyle(
                        //         overlayColor: MaterialStateProperty.all(
                        //             Colors.transparent),
                        //         splashFactory: NoSplash.splashFactory,
                        //       ),
                        //       onPressed: () {
                        //         //TODO:
                        //       },
                        //       child: Text(
                        //         "Vous débutez chez 3D Anatomy ? Créér un compte",
                        //         style: TextStyle(
                        //             color: Colors.indigo, fontSize: 16),
                        //       )),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
