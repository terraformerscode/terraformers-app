import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _searchController = TextEditingController();
  var _loading = false;
  // Index for bottom nav bar
  int _selectedIndex = 0;

  // Routing for bottom nav bar
  void _onItemTapped(int index) {
    setState(() {
      _loading = true;
    });
    switch (index) {
      case 0:
        // _navigatorKey.currentState!.pushNamed("/chat");
        break;
      case 1:
        // _navigatorKey.currentState!.pushNamed("/addlisting");
        break;
      case 2:
        Navigator.of(context).pushNamed("/account");
        break;
    }
    setState(() {
      _selectedIndex = index;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed Page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text("Items will be displayed here."),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _loading ? null : _onItemTapped,
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
      ),
    );
  }
}
