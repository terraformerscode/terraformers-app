import 'dart:convert';
import 'package:client/appimagespath.dart';
import 'package:client/main.dart';
import 'package:client/server_interface/user_registration_API.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum ToggleBetweenCards {
  continueWithEmail,
  emailTextField,
  signUp,
  logIn,
  forgotPassword
}

class _LoginPageState extends State<LoginPage> {
  late Image _globeYellow;

  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _cfmpasswordController;

  late ToggleBetweenCards _selectedCard;

  late final _emailControllerKey = GlobalKey<FormFieldState>();
  late final _usernameControllerKey = GlobalKey<FormFieldState>();
  late final _passwordControllerKey = GlobalKey<FormFieldState>();
  late final _cfmpasswordControllerKey = GlobalKey<FormFieldState>();

  late final _signUpFormKey = GlobalKey<FormState>();

  RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  //=============Routes===================================================
  void _landingPageRoute() {
    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: const LandingPage(),
          duration: const Duration(milliseconds: 750),
          reverseDuration: const Duration(milliseconds: 500)),
    );
  }

  //=========================User Auth Methods=============================

  //=========================Cards=======================================
  Widget currentDisplayCard() {
    switch (_selectedCard) {
      case ToggleBetweenCards.continueWithEmail:
        return continueWithEmailCard();
      case ToggleBetweenCards.emailTextField:
        return emailTextCard();
      case ToggleBetweenCards.signUp:
        return signUpCard();
      case ToggleBetweenCards.logIn:
        return logInCard();
      case ToggleBetweenCards.forgotPassword:
        return forgotPwdCard();
    }
  }

  Widget terraformersYellowGlobe() {
    return SizedBox(
      height: 150,
      width: 150,
      child: _globeYellow,
    );
  }

  Widget continueWithEmailCard() {
    return Column(
      children: [
        Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 80,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 250, height: 40),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedCard = ToggleBetweenCards.emailTextField;
              });
            },
            child: Text(
              'Sign In with Email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(height: 30),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 250, height: 40),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Sign In with Google',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }

  Widget emailTextCard() {
    //TODO: Make better input decoration for buttons
    return Column(
      children: [
        Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          '''Enter your email below. If you have not signed up,
you will be directed to the registration page!''',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        TextFormField(
          key: _emailControllerKey,
          controller: _emailController,
          onChanged: (value) {
            _emailControllerKey.currentState!.validate();
          },
          validator: (email) {
            return (!emailRegExp.hasMatch(email!) || email.isEmpty)
                ? "Please enter a valid email"
                : null;
          },
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Please enter your email'),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCard = ToggleBetweenCards.continueWithEmail;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_emailControllerKey.currentState!.validate()) return;
                bool hasSignedUp = false;
                if (!hasSignedUp) {
                  setState(() {
                    _selectedCard = ToggleBetweenCards.signUp;
                  });
                  // ignore: dead_code
                } else {
                  setState(() {
                    _selectedCard = ToggleBetweenCards.logIn;
                  });
                }
              },
              child: Text(
                'Proceed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget signUpCard() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            key: _usernameControllerKey,
            controller: _usernameController,
            onChanged: (password) {
              _usernameControllerKey.currentState!.validate();
            },
            validator: (password) {
              return (_usernameController.text.isEmpty)
                  ? "Username cannot be empty"
                  : null;
            },
            decoration: const InputDecoration(
                labelText: 'Username', hintText: 'Please enter your username'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: _passwordControllerKey,
            obscureText: true,
            controller: _passwordController,
            onChanged: (password) {
              _passwordControllerKey.currentState!.validate();
            },
            validator: (username) {
              return (_passwordController.text.length < 8)
                  ? "Password needs to be at least 8 characters long"
                  : null;
            },
            decoration: const InputDecoration(
                labelText: 'Password', hintText: 'Please enter your password'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: _cfmpasswordControllerKey,
            obscureText: true,
            controller: _cfmpasswordController,
            onChanged: (password) {
              _cfmpasswordControllerKey.currentState!.validate();
            },
            validator: (cfmpassword) {
              return (_passwordController.text != cfmpassword)
                  ? "Password does not match the one above"
                  : null;
            },
            decoration: const InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Re-enter the same password as above'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedCard = ToggleBetweenCards.continueWithEmail;
                  });
                },
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_signUpFormKey.currentState!.validate()) return;

                  await UserRegistrationAPI.signUp(_emailController.text,
                      _usernameController.text, _passwordController.text);

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? authToken = prefs.getString("authToken");
                  print("Sign up user token: $authToken");

                  if (authToken == null) {
                    SnackBar noTokenMsg = const SnackBar(
                      content:
                          Text('User Registration Failed! No token detected'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(noTokenMsg);
                    return;
                  }
                  SnackBar signUpSuccessfulMsg = const SnackBar(
                    content: Text('Sign Up Successful!'),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(signUpSuccessfulMsg);

                  _passwordController.clear();
                  _usernameController.clear();
                  _cfmpasswordController.clear();

                  setState(() {
                    _selectedCard = ToggleBetweenCards.logIn;
                  });
                },
                child: Center(
                  child: Text(
                    'Register',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget logInCard() {
    return Column(
      children: [
        Text(
          'Log In',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: 30,
        ),
        TextFormField(
          key: _emailControllerKey,
          controller: _emailController,
          validator: (email) {
            return (!emailRegExp.hasMatch(email!) || email.isEmpty)
                ? "Please enter a valid email"
                : null;
          },
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Please enter your Email'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: const InputDecoration(
              labelText: 'Password', hintText: 'Please enter your password'),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCard = ToggleBetweenCards.continueWithEmail;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_emailControllerKey.currentState!.validate()) return;

                bool loggedIn = await UserRegistrationAPI.logIn(
                    _emailController.text, _passwordController.text);
                if (!loggedIn) {
                  SnackBar logInFailed = const SnackBar(
                      content: Text(
                          "Incorrect email or password. Please Try Again"));
                  ScaffoldMessenger.of(context).showSnackBar(logInFailed);
                  return;
                }

                Navigator.of(context).pushNamedAndRemoveUntil(
                    routesMap[Pages.landingPage]!, (route) => false);
              },
              child: Center(
                child: Text(
                  'Log In',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(children: [
          Text(
            'Forgot your password? ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _selectedCard = ToggleBetweenCards.forgotPassword;
              });
            },
            child: Text(
              'Click here',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ])
      ],
    );
  }

  Widget forgotPwdCard() {
    //TODO: Make better input decoration for buttons
    return Column(
      children: [
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          '''Enter the email you signed up with.
An OTP will be sent to this email
to reset your password!''',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        TextFormField(
          key: _emailControllerKey,
          controller: _emailController,
          onChanged: (value) {
            _emailControllerKey.currentState!.validate();
          },
          validator: (email) {
            return (!emailRegExp.hasMatch(email!) || email.isEmpty)
                ? "Please enter a valid email"
                : null;
          },
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Please enter your email'),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedCard = ToggleBetweenCards.logIn;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_emailControllerKey.currentState!.validate()) return;
                // TODO: Verify email exists
                // TODO: Navigate to OTP screen + send OTP to email
              },
              child: Text(
                'Proceed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }


  //=====================Flutter Override Methods==============================
  @override
  void initState() {
    _globeYellow = Image.asset(
      AppImagesPath.globeYellow,
      fit: BoxFit.fitHeight,
    );
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _cfmpasswordController = TextEditingController();
    _selectedCard = ToggleBetweenCards.continueWithEmail;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _cfmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          // Phone screen's height and width to wrap column
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                terraformersYellowGlobe(),
                const SizedBox(height: 40),
                currentDisplayCard(),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
