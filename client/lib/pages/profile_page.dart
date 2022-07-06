import 'package:client/server_interface/peppermint_API.dart';
import 'package:client/server_interface/user_registration_api.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _searchController = TextEditingController();

  //=================Authentication============
  void _logout() async {
    bool success = await UserRegistrationAPI.logout();
    successFailSnackBar(success, "Logged out successfully",
        "Failed to log out, please try again");
    if (success) {
      _loginRoute();
    }
  }

  //=========================Snackbar Methods=============================
  void successFailSnackBar(bool cond, String successText, String failText) {
    if (!cond) {
      SnackBar failedSnackbar = SnackBar(
        content: Text(failText),
      );
      ScaffoldMessenger.of(context).showSnackBar(failedSnackbar);
      return;
    }
    SnackBar successSnackbar = SnackBar(
      content: Text(successText),
    );
    ScaffoldMessenger.of(context).showSnackBar(successSnackbar);
  }

  //=================Routes====================
  void _loginRoute() {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            child: const LoginPage(),
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 500)),
        (route) => false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TFAppBar().build(context, "Profile"),
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
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    _logout();
                  },
                  child: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          TFBottomNavBar().build(context, BottomNavBarOptions.profile),
    );
  }
}
