import 'package:client/apptheme.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';

enum BottomNavBarOptions { home, countryVisa, community, profile }

class TFBottomNavBar {
  var _loading = false;
  // Index for bottom nav bar
  late int _selectedIndex;

  // Routing for bottom nav bar
  void _onItemTapped(int index, BuildContext context) {
    _loading = true;
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
        break;
      case 1:
        Navigator.of(context).pushNamed(routesMap[Pages.countryVisaPage]!);
        break;
      case 2:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
        break;
      case 3:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
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
    return BottomNavigationBar(
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
    );
  }
}
