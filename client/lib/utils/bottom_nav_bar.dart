import 'package:client/main.dart';
import 'package:flutter/material.dart';

class TFBottomNavBar {
  var _loading = false;
  // Index for bottom nav bar
  int _selectedIndex = 0;

  // Routing for bottom nav bar
  void _onItemTapped(int index, BuildContext context) {
    _loading = true;
    switch (index) {
      case 0:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
        break;
      case 1:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
        break;
      case 2:
        Navigator.of(context).pushNamed(routesMap[Pages.profilePage]!);
        break;
    }
    _selectedIndex = index;
    _loading = false;
  }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _loading
          ? null
          : (index) {
              _onItemTapped(index, context);
            },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Listing',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.face_outlined),
          label: 'User Profile',
        ),
      ],
    );
  }
}
