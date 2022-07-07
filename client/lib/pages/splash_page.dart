import 'dart:async';
import 'dart:developer';

import 'package:client/pages/profile_page.dart';
import 'package:client/server_interface/user_registration_api.dart';
import 'package:client/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //=============Authentication================================
  Future<void Function()> _checkLoggedIn() {
    bool pushReplacement = true;
    return UserRegistrationAPI.loggedInUser().then((loggedIn) => () =>
        loggedIn
        ? Routes.profileRoute(context, pushReplacement)
        : Routes.loginRoute(context, pushReplacement));
  }

  Future<Timer> _startTime() async {
    var duration = const Duration(seconds: 2, milliseconds: 500);
    void Function() _nextRoute = await _checkLoggedIn();
    return Timer(duration, _nextRoute);
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Thrive anytime, anywhere",
                style: Theme.of(context).textTheme.headlineSmall,
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
