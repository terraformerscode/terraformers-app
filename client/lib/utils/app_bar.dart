import 'package:client/main.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';

class TFAppBars {
  PreferredSizeWidget buildGrey(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  PreferredSizeWidget buildMediumBlue(BuildContext context, {String title = ""}) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: TerraformersConst.mediumBlue,
      elevation: 0,
    );
  }
}
