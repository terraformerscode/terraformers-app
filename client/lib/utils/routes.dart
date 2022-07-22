import 'package:client/main.dart';
import 'package:client/pages/country_visa_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static bool currentRoute(
    BuildContext context,
    Pages page,
  ) {
    ModalRoute<Object?>? route = ModalRoute.of(context);
    String? routeName = route?.settings.name;
    print("Route name: $routeName");
    return routeName == routesMap[page] ? true : false;
  }

  static void buildNormalRoute(
    BuildContext context, bool pushReplacement, Widget page) {
    pushReplacement
      ? Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: page,
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 500)))
      : Navigator.of(context).push(PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: page,
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 500)));
  }


  static void profileRoute(BuildContext context, bool pushReplacement) {
    buildNormalRoute(context, pushReplacement, const ProfilePage());
  }

  static void loginRoute(BuildContext context, bool pushReplacement) {
    buildNormalRoute(context, pushReplacement, const LoginPage());
  }

  static void countryVisaRoute(BuildContext context, bool pushReplacement) {
    buildNormalRoute(context, pushReplacement, const CountryVisaPage());
  }

  static void loginRouteLeftToRight(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: const LoginPage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)),
        (route) => false);
  }

}
