import 'package:client/pages/profile_page.dart';
import 'package:client/utils/app_bar.dart';
import 'package:client/utils/bottom_nav_bar.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CountryVisaPage extends StatefulWidget {
  const CountryVisaPage({Key? key}) : super(key: key);

  @override
  _CountryVisaPageState createState() => _CountryVisaPageState();
}

class _CountryVisaPageState extends State<CountryVisaPage> {
  
  
  //=========================Cards=======================================
  Widget currentDisplayCard() {
    return const Text("Country here");
  }


  //=====================Flutter Override Methods==============================
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TFAppBar().build(context, ""),
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
                currentDisplayCard(),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: TFBottomNavBar().build(context, BottomNavBarOptions.countryVisa),
    );
  }
}
