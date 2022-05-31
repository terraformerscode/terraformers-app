import 'dart:io';
import 'package:client/appimagespath.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Image globeYellow;

  @override
  void initState() {
    super.initState();
    globeYellow = Image.asset(AppImagesPath.globeYellow);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              globeYellow,
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 18),
              Row(
                children: const [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: null,
                      child: Text('Connect with Metamask'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
