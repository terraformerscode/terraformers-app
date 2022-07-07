import 'package:client/utils/routes.dart';
import 'package:client/web3/peppermint_API.dart';
import 'package:client/server_interface/user_registration_api.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:client/utils/snackbar.dart';
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
    TFSnackBar.successFailSnackBar(success, "Logged out successfully",
        "Failed to log out, please try again", context);
    if (success) {
      Routes.loginRouteLeftToRight(context);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TFAppBars().buildGrey(context, "Profile"),
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
