import 'package:client/main.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static bool sameRoute(
    BuildContext context,
  ) {
    ModalRoute<Object?>? route = ModalRoute.of(context);
    String? routeName = route?.settings.name;
    return routeName == null || routeName == routesMap[Pages.profilePage]
        ? true
        : false;
  }

  static void profileRoute(BuildContext context, bool pushReplacement) {
    if (sameRoute(context)) {
      return;
    }

    pushReplacement
        ? Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const ProfilePage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)))
        : Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const ProfilePage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)));
  }

  static void loginRoute(BuildContext context, bool pushReplacement) {
    if (sameRoute(context)) {
      return;
    }

    pushReplacement
        ? Navigator.of(context).pushReplacement(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const LoginPage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)))
        : Navigator.of(context).push(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const LoginPage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)));
  }
}
