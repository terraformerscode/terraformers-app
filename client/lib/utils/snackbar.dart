import 'package:flutter/material.dart';

class TFSnackBar {
  //=========================Snackbar Methods=============================
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
}