import 'package:flutter/material.dart';
import 'package:client/apptheme.dart';
import 'package:client/pages/landing_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/splash_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terraformers App',
      theme: AppTheme().buildThemeData(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/landing': (_) => const LandingPage(),
      },
    );
  }
}
