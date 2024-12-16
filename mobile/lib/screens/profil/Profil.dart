import 'package:TerraViva/components/SnackBarUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:TerraViva/models/user.dart';
import 'dart:math' as math;
import '../../app_skoleton/appSkoleton.dart';
import '../../controller/logOutController.dart';
import '../../controller/userDetailController.dart';
import '../../loginScreen.dart';
import '../../service/serviceLocator.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final storage = const FlutterSecureStorage();
  final loginController = getIt<LogoutController>();
  final userDetailController = getIt<UserDetailController>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Add a state variable to force refresh
  Key _refreshKey = UniqueKey();

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
                  ))),
            )));
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
                  'Connection Failed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
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
    }
  }

  Future<void> _showEditDialog(BuildContext context, User user) async {
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName);
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          contentPadding: const EdgeInsets.all(24.0),
          title: const Text(
            'Edit Profile',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: const Icon(Icons.person, color: Colors.blue),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      prefixIcon:
                          const Icon(Icons.person_outline, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            // Update user details
                            await userDetailController.updateUserInfo(
                              firstNameController.text,
                              lastNameController.text,
                            );

                            // Ensure the widget is still mounted before performing actions
                            if (context.mounted) {
                              // Close the dialog after saving
                              Navigator.pop(context);

                              // Show SnackBar
                              SnackBarUtils.showCustomSnackBar(
                                context,
                                message: 'Profile updated successfully!',
                                type: SnackBarType.success,
                              );

                              // Trigger a refresh after the update
                              setState(() {
                                _refreshKey = UniqueKey();
                                isLoading = false;
                              });
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to update: $e")),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: const Color(0xFF6D83F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator() // Show loading spinner when isLoading is true
                            : const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<void> _showEditDialog(BuildContext context, User user) async {
  //   final TextEditingController firstNameController =
  //       TextEditingController(text: user.firstName);
  //   final TextEditingController lastNameController =
  //       TextEditingController(text: user.lastName);
  //   bool isLoading = false; // Declare this at the top of your widget

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //         ),
  //         contentPadding: const EdgeInsets.all(24.0),
  //         title: const Text(
  //           'Edit Profile',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 16.0),
  //                 child: TextField(
  //                   controller: firstNameController,
  //                   decoration: InputDecoration(
  //                     labelText: 'First Name',
  //                     labelStyle: const TextStyle(color: Colors.grey),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       borderSide: const BorderSide(color: Colors.grey),
  //                     ),
  //                     prefixIcon: const Icon(Icons.person, color: Colors.blue),
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(bottom: 16.0),
  //                 child: TextField(
  //                   controller: lastNameController,
  //                   decoration: InputDecoration(
  //                     labelText: 'Last Name',
  //                     labelStyle: const TextStyle(color: Colors.grey),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       borderSide: const BorderSide(color: Colors.grey),
  //                     ),
  //                     prefixIcon:
  //                         const Icon(Icons.person_outline, color: Colors.blue),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextButton(
  //                       onPressed: () => Navigator.pop(context),
  //                       style: TextButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 15.0),
  //                         backgroundColor: Colors.grey[200],
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                         ),
  //                       ),
  //                       child: const Text(
  //                         "Cancel",
  //                         style: TextStyle(
  //                           color: Colors.blue,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Expanded(
  //                     child: TextButton(
  //                       onPressed: () async {
  //                         setState(() {
  //                           isLoading = true;
  //                         });

  //                         // try {
  //                         //   // Update user details
  //                         //   await userDetailController.updateUserInfo(
  //                         //     firstNameController.text,
  //                         //     lastNameController.text,
  //                         //   );

  //                         //   // Close the dialog after saving
  //                         //   Navigator.pop(context);

  //                         //   // Use the root context or pass a context from the scaffold
  //                         //   ScaffoldMessenger.of(context).showSnackBar(
  //                         //     const SnackBar(
  //                         //       content: Text("Profile updated successfully!"),
  //                         //       duration: Duration(
  //                         //           seconds: 2), // Optional: customize duration
  //                         //     ),
  //                         //   );

  //                         //   setState(() {
  //                         //     _refreshKey = UniqueKey();
  //                         //     isLoading = false;
  //                         //   });
  //                         //   // if (context.mounted) {
  //                         //   // }
  //                         // } catch (e) {
  //                         //   setState(() {
  //                         //     isLoading = false;
  //                         //   });
  //                         //   ScaffoldMessenger.of(context).showSnackBar(
  //                         //     SnackBar(content: Text("Failed to update: $e")),
  //                         //   );
  //                         // }
  //                         try {
  //                           // Update user details
  //                           await userDetailController.updateUserInfo(
  //                             firstNameController.text,
  //                             lastNameController.text,
  //                           );

  //                           // Ensure the widget is still mounted before performing actions
  //                           if (context.mounted) {
  //                             // Close the dialog after saving
  //                             Navigator.pop(context);

  //                             SnackBarUtils.showCustomSnackBar(
  //                               context,
  //                               message: 'Profile updated successfully!',
  //                               type: SnackBarType.success,
  //                             );

  //                             // Trigger a refresh after the update
  //                             setState(() {
  //                               _refreshKey = UniqueKey();
  //                               isLoading = false;
  //                             });
  //                           }
  //                         } catch (e) {
  //                           setState(() {
  //                             isLoading = false;
  //                           });
  //                           SnackBarUtils.showCustomSnackBar(
  //                             context,
  //                             message: 'Failed to update: $e',
  //                             type: SnackBarType.error,
  //                           );
  //                         }
  //                       },
  //                       style: TextButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 15.0),
  //                         backgroundColor: const Color(0xFF6D83F2),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                         ),
  //                       ),
  //                       child: isLoading
  //                           ? const CircularProgressIndicator() // Show loading spinner when isLoading is true
  //                           : const Text(
  //                               "Save",
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 16,
  //                               ),
  //                             ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF6D83F2),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: 50,
        // backgroundColor: const Color.fromARGB(255, 246, 246, 246),
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF6D83F2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Custom back icon
          onPressed: () {
            // Custom back button action
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 60),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(0.0, 24.0, 0.0, 0.0),
                title: const Text(
                  'Log out',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Do you really want to log out?",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => logout(context),
                            child: const Text(
                              "Log out",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<User>(
            key: _refreshKey,
            future: userDetailController.getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: AppSkoleton(
                      width: 80,
                      height: 20,
                      margin:
                          const EdgeInsets.only(bottom: 8, right: 5, left: 5),
                      radius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const Text("No user data available.");
              }

              User? user = snapshot.data;

              return ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.indigo.shade100,
                          backgroundImage:
                              const AssetImage("assets/images/man.png"),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user!.firstName + ' ' + user.lastName,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 5),
                            InkWell(
                              onTap: () => _showEditDialog(context, user),
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF6D83F2)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                      height: 20, color: Color.fromARGB(255, 212, 212, 212)),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: const Icon(
                      Icons.email,
                      color: Colors.indigo, // Icon color
                      size: 28,
                    ),
                    title: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800], // Title text color
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87, // Subtitle text color
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Color(0xFF6D83F2), // Copy icon color
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: user.email));
                        SnackBarUtils.showCustomSnackBar(
                          context,
                          message: 'Email copied!',
                          type: SnackBarType.success,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Terraviva Team",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Version 1.0.0",
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
    );
  }
}
