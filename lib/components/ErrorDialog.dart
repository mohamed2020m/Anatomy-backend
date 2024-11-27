import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorDialog({
    Key? key, 
    this.errorMessage = "Sorry! We're unable to load data", 
    required this.onRetry
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Icon(
        Icons.error_outline, 
        color: Colors.red, 
        size: 60
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Try again later',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onRetry,
            style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFF6D83F2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            ),
            child: const Text('Retry'),
        ),
      ],
    );
  }
}