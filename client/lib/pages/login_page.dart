import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 150),
            Text('Welcome to',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headline6?.fontSize ?? 32)),
            Text('JustShareLah!',
                style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.headline3?.fontSize ?? 48)),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: null,
                    child: Text(_isLoading ? 'Loading' : 'Log In'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.ltr,
              children: [
                const Text("Don't have an account? "),
                InkWell(
                  child: Text(
                    'Sign up.',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.teal[600],
                    ),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
