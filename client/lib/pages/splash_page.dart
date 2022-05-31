import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  
  // //TODO: Animation not working
  // Route _createLoginRouteAnim() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
  //     transitionDuration: const Duration(milliseconds: 5000),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(0.0, 1.0);
  //       const end = Offset.zero;
  //       const curve = Curves.ease;

  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  void _loginRoute() {
    // Navigator.of(context).pushReplacement(_createLoginRouteAnim());
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: const LoginPage(),
        duration: const Duration(milliseconds: 2000),
      )
    );
  }

  Future<Timer> _startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, _loginRoute);
  }

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Terraformers",
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                "Thrive anytime, anywhere",
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 80),
              const CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Color.fromARGB(255, 255, 200, 72),
                strokeWidth: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
