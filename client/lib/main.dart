import 'package:flutter/material.dart';
import 'package:client/apptheme.dart';
import 'package:client/pages/landing_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

enum Pages {
  splashPage,
  loginPage,
  landingPage,
}

var routesMap = <Pages, String>{
  Pages.splashPage: '/',
  Pages.loginPage: '/login',
  Pages.landingPage: '/landing',
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terraformers App',
      theme: AppTheme().buildThemeData(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        routesMap[Pages.splashPage]!: (_) => const SplashPage(),
        routesMap[Pages.loginPage]!: (_) => const LoginPage(),
        routesMap[Pages.landingPage]!: (_) => const LandingPage(),
      },
    );
  }
}
