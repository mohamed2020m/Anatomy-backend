import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:TerraViva/models/user.dart';
import 'dart:math' as math;
import '../../app_skoleton/appSkoleton.dart';
import '../../controller/logOutController.dart';
import '../../controller/userDetailController.dart';
import '../../loginScreen.dart';
import '../../service/serviceLocator.dart';

class Profil extends StatelessWidget {
  final storage = const FlutterSecureStorage();
  final loginController = getIt<LogoutController>();
  final userDetailController = getIt<UserDetailController>();

  Profil({super.key});

  deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future logout(BuildContext context) async {
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
      dynamic response = await loginController.logout();
      deleteToken();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                buttonPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                contentPadding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
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
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 24),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<User>(
        future: userDetailController.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.only(top: 8),
              child: AppSkoleton(
                width: 80,
                height: 20,
                margin: const EdgeInsets.only(bottom: 8, right: 5, left: 5),
                radius: BorderRadius.circular(5),
              ),
            );
          } else if (snapshot.hasData) {
            return Column(children: [
              // profil info (image+nom+prenom+email)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: const Hero(
                          transitionOnUserGestures: false,
                          tag: "HmzEzh",
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                AssetImage("assets/images/man.png"),
                            backgroundColor: Color.fromARGB(48, 63, 81, 181),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, bottom: 4),
                child: Text(
                  "${snapshot.data!.firstName} ${snapshot.data!.lastName}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                  child: Text(snapshot.data!.email,
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)))
            ]);
          }
          return Container();
        },
      ),
      floatingActionButton: Container(
          margin:
              const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 16),
          height: 50,
          child: Material(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 233, 233, 233),
              child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  //TODO:
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              insetPadding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              buttonPadding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              contentPadding: const EdgeInsets.fromLTRB(
                                  0.0, 24.0, 0.0, 0.0),
                              title: const Text(
                                'Log out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 200,
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8, bottom: 24),
                                    child: const Text(
                                      "Voulez-vous vraiment vous déconnecter ?",
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
                                                  top: BorderSide(
                                                      color: Colors.grey),
                                                  right: BorderSide(
                                                      color: Colors.grey))),
                                          height: 50,
                                          child: const Center(
                                            child: Text("Cancel",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                      )),
                                      Expanded(
                                          child: InkWell(
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                        ),
                                        onTap: () => logout(context),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                            top: BorderSide(color: Colors.grey),
                                          )),
                                          height: 50,
                                          child: const Center(
                                            child: Text(
                                              "Log out",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ));
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 16),
                        child: Transform.rotate(
                          angle: -math.pi,
                          child: const Icon(
                            Icons.logout,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const Text(
                        "Log out",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 16),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          textDirection: TextDirection.rtl,
                          size: 18,
                        ),
                      ),
                    ],
                  )))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
