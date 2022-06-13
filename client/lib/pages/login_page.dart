import 'dart:convert';

import 'package:client/appimagespath.dart';
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

class _LoginPageState extends State<LoginPage> {
  late Image _globeYellow;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _cfmpasswordController;
  late bool _showEmailTextField;

  //---------------Routes---------------
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

  //--------------Widgets----------------
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
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 80,),
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 250, height: 40),
          child: ElevatedButton(
            onPressed: () {
              //TODO: Perform user email validation -- Have they signed up or not?
              // Perform token validation as well
              setState(() {
                _showEmailTextField = true;
              });
            },
            child: Text(
              'Sign In with Email',
              style: Theme.of(context).textTheme.headline3,
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
              style: Theme.of(context).textTheme.headline3,
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
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 30,),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Please enter your email'
          ),
        ),
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: () {
                //TODO: Set all the prev states back, if any
                setState(() {
                  _showEmailTextField = false;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Proceed',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget signUpCard() {
    return Column(
      children: [
        Text(
          'Sign Up',
          style: Theme.of(context).textTheme.headline2,
        ),
        const SizedBox(height: 30,),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
              labelText: 'Email', hintText: 'Please enter your email'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
              labelText: 'Password', hintText: 'Please enter your password'),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _cfmpasswordController,
          decoration: const InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter the same password as above'),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            ElevatedButton(
              onPressed: null,
              child: Center(
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //-----------Flutter Override Methods------------
  @override
  void initState() {
    _globeYellow = Image.asset(
      AppImagesPath.globeYellow,
      fit: BoxFit.fitHeight,
    );
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _cfmpasswordController = TextEditingController();
    _showEmailTextField = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              const SizedBox(height: 80),
              terraformersYellowGlobe(),
              const SizedBox(height: 40),
              Visibility(
                visible: _showEmailTextField,
                replacement: continueWithEmailCard(),
                child: emailTextCard(),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

_signUp(email, password) async {
  //TODO: Change URL to server host url
  var url = "http://10.0.2.2:5000/signup";

  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parseToken = jsonDecode(response.body);
  await prefs.setString('authToken', parseToken["authToken"]);

  // if (response.statusCode == 201) {
  //   // If the server did return a 201 CREATED response,
  //   // then parse the JSON.

  // } else {
  //   // If the server did not return a 201 CREATED response,
  //   // then throw an exception.
  //   throw Exception('Failed to create album.');
  // }
}

// SharedPreferences prefs = await SharedPreferences.getInstance();
//                     String? authToken = prefs.getString("authToken");
//                     print(authToken);
//                     if (authToken == null) return;

//                     _landingPageRoute();