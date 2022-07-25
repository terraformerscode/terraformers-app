import 'package:client/apptheme.dart';
import 'package:client/main.dart';
import 'package:client/utils/routes.dart';
import 'package:flutter/material.dart';

enum BottomNavBarOptions { home, countryVisa, community, profile }

class TFBottomNavBar {
  var _loading = false;
  // Index for bottom nav bar
  late int _selectedIndex;
  Color borderColor = const Color.fromARGB(255, 127, 152, 156);

  // Routing for bottom nav bar
  void _onItemTapped(int index, BuildContext context) {
    _loading = true;
    switch (index) {
      case 0:
        Routes.profileRoute(context, false);
        break;
      case 1:
        Routes.allCountryVisaRoute(context, false);
        break;
      case 2:
        Routes.profileRoute(context, false);
        break;
      case 3:
        Routes.profileRoute(context, false);
        break;
    }
    _selectedIndex = index;
    _loading = false;
  }

  int optionToIndex(BottomNavBarOptions selectedOption) {
    switch (selectedOption) {
      case BottomNavBarOptions.home:
        return 0;
      case BottomNavBarOptions.countryVisa:
        return 1;
      case BottomNavBarOptions.community:
        return 2;
      case BottomNavBarOptions.profile:
        return 3;
    }
  }

  Widget build(BuildContext context, BottomNavBarOptions selectedOption) {
    _selectedIndex = optionToIndex(selectedOption);
    return Container( 
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor, width: 1.5))),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: navBtnUnselectColor,
        selectedItemColor: navBtnSelectColor,
        currentIndex: _selectedIndex,
        onTap: _loading
            ? null
            : (index) {
                _onItemTapped(index, context);
              },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Country Visa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'User Profile',
          ),
        ],
      ),
    );
  }
}
