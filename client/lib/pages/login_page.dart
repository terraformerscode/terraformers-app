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
  late Image globeYellow;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    globeYellow = Image.asset(
      AppImagesPath.globeYellow,
      fit: BoxFit.fitHeight,
    );
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //---------------Routes---------------
  void _landingPageRoute() {
    Navigator.pushReplacement(
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
      child: globeYellow,
    );
  }

  Widget continueWithEmailBtn() {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 250, height: 40),
      child: ElevatedButton(
        onPressed: () async {
          _signUp(_emailController.text, _passwordController.text);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Text(
                'Continue with Email',
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
    );
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
              const Expanded(child: SizedBox()),
              terraformersYellowGlobe(),
              const SizedBox(height: 40),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 80),
              continueWithEmailBtn(),
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

// TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//               ),
//               const SizedBox(height: 32),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   const Expanded(
//                     child: SizedBox(),
//                   ),
//                   ConstrainedBox(
//                     constraints:
//                         const BoxConstraints.tightFor(width: 130, height: 40),
//                     child: ElevatedButton(
//                       onPressed: null,
//                       child: Center(
//                         child: Text(
//                           'Register',
//                           style: Theme.of(context).textTheme.headline3,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),

// SharedPreferences prefs = await SharedPreferences.getInstance();
//                     String? authToken = prefs.getString("authToken");
//                     print(authToken);
//                     if (authToken == null) return;

//                     _landingPageRoute();


// ------------------ BEGINNING OF PHANTOM CARD -------------
              //
              //
              // const SizedBox(height: 20),
              // Text(
              //   'or',
              //   style: Theme.of(context).textTheme.headline3,
              // ),
              // const SizedBox(height: 20),
              // Row(
              //   children: [
              //     const Expanded(
              //       child: SizedBox(),
              //     ),
              //     ConstrainedBox(
              //       constraints: const BoxConstraints.tightFor(width: 160, height: 40),
              //       child:
              //       ElevatedButton(
              //         onPressed: null,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           mainAxisSize: MainAxisSize.max,
              //           children: [
              //             Center(
              //               child: Text(
              //                 'Phantom',
              //                 style: Theme.of(context).textTheme.headline3,
              //               ),
              //             ),
              //             const Icon(
              //               Octicons.line_arrow_right,
              //               color: Colors.white,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //     const Expanded(
              //       child: SizedBox(),
              //     ),
              //   ],
              // ),
              //
              //
              // ------------------ END OF PHANTOM CARD -------------