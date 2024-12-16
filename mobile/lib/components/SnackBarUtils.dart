import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

class SnackBarUtils {
  static void showCustomSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
  }) {
    Color backgroundColor;
    IconData icon;

    // Define styles for different SnackBar types
    switch (type) {
      case SnackBarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case SnackBarType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case SnackBarType.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        // action: SnackBarAction(
        //   label: actionText,
        //   textColor: Colors.white,
        //   onPressed: () {
        //     // Handle action if needed
        //   },
        // ),
      ),
    );
  }
}
