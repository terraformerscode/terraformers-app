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
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Expanded(
                    child: SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints.tightFor(width: 130, height: 40),
                    child: ElevatedButton(
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Center(
                            child: Text(
                              'Sign in',
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
                ],
              ),
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
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
