import 'package:flutter/material.dart';

class CustomSnackbar {
  static SnackBar build({
    required String message,
    Color backgroundColor = Colors.blue,
    IconData? iconData,
    String actionText = '',
    VoidCallback? onPressed,
    Duration duration = const Duration(seconds: 3),
  }) {
    return SnackBar(
      duration: duration,
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          if (iconData != null) ...[
            Icon(iconData, color: Colors.white),
            SizedBox(width: 8),
          ],
          Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      action: onPressed != null
          ? SnackBarAction(
        label: actionText,
        textColor: Colors.white,
        onPressed: onPressed,
      )
          : null,
    );
  }
}

