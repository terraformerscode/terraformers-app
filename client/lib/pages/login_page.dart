import 'dart:io';
import 'package:client/appimagespath.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';

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
    globeYellow = Image.asset(
      AppImagesPath.globeYellow,
      fit: BoxFit.fitHeight,
    );
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
              const SizedBox(height: 160),
              SizedBox(
                height: 150,
                width: 150,
                child: globeYellow,
              ),
              const SizedBox(height: 40),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 100),
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 160, height: 40),
                    child:
                    ElevatedButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Text(
                              'Metamask',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          const Icon(
                            Octicons.line_arrow_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'or',
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 160, height: 40),
                    child:
                    ElevatedButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Text(
                              'Phantom',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                          const Icon(
                            Octicons.line_arrow_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
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
