import 'package:flutter/material.dart';

class AppLogger {
  static final List<LogMessage> logMessages = [];

  static void log({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    logMessages.add(LogMessage(icon: icon, message: message, color: color));
  }

  static void logException(String prefix, Object e) {
    logError('$prefix ${e.toString()}');
  }

  static void logError(String message) {
    log(icon: Icons.error, message: message, color: Colors.red);
  }

  static void logWarning(String message) {
    log(icon: Icons.warning, message: message, color: Colors.orange);
  }

  static void logInfo(String message) {
    log(icon: Icons.info, message: message, color: Colors.transparent);
  }

  static void logSuccess(String message) {
    log(icon: Icons.check_circle, message: message, color: Colors.green);
  }
}

class LogMessage {
  final IconData icon;
  final String message;
  final Color color;

  const LogMessage({
    required this.icon,
    required this.message,
    required this.color,
  });
}

void showSnackbar(BuildContext context, String msg, {Color? backgroundColor, IconData? icon}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) Icon(icon),
          Text(msg),
        ],
      ),
      backgroundColor: backgroundColor,
    ),
  );
}

void showExceptionSnackbar(BuildContext context, String prefix, Object e) {
  showSnackbar(context, '$prefix ${e.toString()}', backgroundColor: Colors.red);
}