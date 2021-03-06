import 'package:client/appimagespath.dart';
import 'package:client/server_interface/user_registration_api.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/routes.dart';
import 'package:client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';

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
  forgotPassword,
  forgotPasswordOTPVerification,
  resetPassword
}

class _LoginPageState extends State<LoginPage> {
  late Image _globeYellow;

  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _cfmpasswordController;
  late TextEditingController _resetpasswordController;
  late TextEditingController _cfmresetpasswordController;

  late ToggleBetweenCards _selectedCard;

  late final _emailControllerKey = GlobalKey<FormFieldState>();
  late final _usernameControllerKey = GlobalKey<FormFieldState>();
  late final _passwordControllerKey = GlobalKey<FormFieldState>();
  late final _cfmpasswordControllerKey = GlobalKey<FormFieldState>();
  late final _resetpasswordControllerKey = GlobalKey<FormFieldState>();
  late final _cfmresetpasswordControllerKey = GlobalKey<FormFieldState>();

  late final _signUpFormKey = GlobalKey<FormState>();

  RegExp emailRegExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

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
      case ToggleBetweenCards.forgotPasswordOTPVerification:
        return otpCard();
      case ToggleBetweenCards.resetPassword:
        return resetPwdCard();
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
                bool userExists =
                    await UserRegistrationAPI.userExists(_emailController.text);
                if (!userExists) {
                  setState(() {
                    _selectedCard = ToggleBetweenCards.signUp;
                  });
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
            onChanged: (username) {
              _usernameControllerKey.currentState!.validate();
            },
            validator: (username) {
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
            validator: (password) {
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

                Routes.profileRoute(context, false);
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
        const SizedBox(height: 40),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forgot your password? Click ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _selectedCard = ToggleBetweenCards.forgotPassword;
                });
              },
              child: Text(
                'here.',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: TerraformersConst.yellow,
                    ),
              ),
            ),
          ],
        )
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

                bool otpSent = await UserRegistrationAPI.sendResetOTP(
                    _emailController.text);
                TFSnackBar.successFailSnackBar(
                    otpSent,
                    "OTP Sent to ${_emailController.text}",
                    "Failed sending OTP", context);

                setState(() {
                  _selectedCard =
                      ToggleBetweenCards.forgotPasswordOTPVerification;
                });
              },
              child: Text(
                'Send OTP',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget otpCard() {
    String? otp;
    final TextEditingController otpField = TextEditingController();
    return Column(
      children: [
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          '''Enter the OTP sent by Auth0 to your email''',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              activeColor: TerraformersConst.lightBlue,
              selectedColor: TerraformersConst.yellow,
              inactiveColor: TerraformersConst.lightBlue),
          animationDuration: const Duration(milliseconds: 300),
          controller: otpField,
          onCompleted: (otp) async {
            bool verified = await UserRegistrationAPI.verifyResetOTP(
                _emailController.text, otp);
            TFSnackBar.successFailSnackBar(
                verified, "Verified!", "OTP Verification Failed", context);

            setState(() {
              _selectedCard = ToggleBetweenCards.resetPassword;
            });
          },
          onChanged: (value) {},
          beforeTextPaste: (text) {
            if (text == null) return false;
            return int.tryParse(text) != null;
          },
          appContext: context,
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
                  _selectedCard = ToggleBetweenCards.forgotPassword;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget resetPwdCard() {
    //TODO: Make better input decoration for buttons
    return Column(
      children: [
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          '''Enter your new password''',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          key: _resetpasswordControllerKey,
          controller: _resetpasswordController,
          onChanged: (pwd) {
            _resetpasswordControllerKey.currentState!.validate();
          },
          validator: (pwd) {
            return (_resetpasswordController.text.length < 8)
                ? "Password needs to be at least 8 characters long"
                : null;
          },
          decoration: const InputDecoration(
            labelText: 'New Password',
            hintText: 'Please enter your new password',
          ),
        ),
        const SizedBox(height: 30),
        TextFormField(
          obscureText: true,
          key: _cfmresetpasswordControllerKey,
          controller: _cfmresetpasswordController,
          onChanged: (cfmpwd) {
            _cfmresetpasswordControllerKey.currentState!.validate();
          },
          validator: (cfmpassword) {
            return (_resetpasswordController.text != cfmpassword)
                ? "Password does not match the one above"
                : null;
          },
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Please enter the same password as above',
          ),
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
                  _selectedCard = ToggleBetweenCards.forgotPassword;
                });
              },
              child: Text(
                'Back',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!_cfmresetpasswordControllerKey.currentState!.validate() ||
                    !_resetpasswordControllerKey.currentState!.validate()) {
                  return;
                }

                bool resetSuccess = await UserRegistrationAPI.resetPassword(
                    _emailController.text, _resetpasswordController.text);
                TFSnackBar.successFailSnackBar(
                    resetSuccess,
                    "Password Reset! Log In again",
                    "Password Reset Failed. Try Again.", context);

                setState(() {
                  _selectedCard = ToggleBetweenCards.logIn;
                });
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
    _resetpasswordController = TextEditingController();
    _cfmresetpasswordController = TextEditingController();

    _selectedCard = ToggleBetweenCards.continueWithEmail;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _cfmpasswordController.dispose();
    _resetpasswordController.dispose();
    _cfmresetpasswordController.dispose();
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
