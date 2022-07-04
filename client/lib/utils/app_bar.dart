import 'package:client/main.dart';
import 'package:flutter/material.dart';

class TFAppBar {

  PreferredSizeWidget build(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }
}
