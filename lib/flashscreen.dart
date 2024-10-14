import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(
          child: const CupertinoActivityIndicator(
        radius: 15,
      )),
    );
  }
}
