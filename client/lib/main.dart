import 'package:client/pages/country_visa_page.dart';
import 'package:flutter/material.dart';
import 'package:client/apptheme.dart';
import 'package:client/pages/profile_page.dart';
import 'package:client/pages/login_page.dart';
import 'package:client/pages/splash_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

enum Pages {
  splashPage,
  loginPage,
  profilePage,
  countryVisaPage,
}

var routesMap = <Pages, String>{
  Pages.splashPage: '/',
  Pages.loginPage: '/login',
  Pages.profilePage: '/profile',
  Pages.countryVisaPage: '/countryVisa',
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
        routesMap[Pages.profilePage]!: (_) => const ProfilePage(),
        routesMap[Pages.countryVisaPage]!: (_) => const CountryVisaPage(),
      },
    );
  }
}
