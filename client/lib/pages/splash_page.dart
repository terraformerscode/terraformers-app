import 'dart:async';

import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  loginRoute() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, loginRoute);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
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
