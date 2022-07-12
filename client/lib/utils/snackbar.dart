import 'package:flutter/material.dart';

class TFSnackBar {
  static void successFailSnackBar(bool cond, String successText, String failText, BuildContext context) {
    if (!cond) {
      SnackBar failedSnackbar = SnackBar(
        content: Text(failText),
      );
      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar);
      return;
    }
    SnackBar successSnackbar = SnackBar(
      content: Text(successText),
    );
    ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
  }

  static void showSnackBar({
    required String message,
    required BuildContext context,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  static void showErrorSnackBar({required String message, required BuildContext context}) {
    showSnackBar(message: message, context: context, backgroundColor: Colors.red);
  }
}