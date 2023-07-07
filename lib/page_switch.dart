import 'package:flutter/material.dart';
import 'package:popcorn_v2/home.dart';
import 'package:popcorn_v2/profile_page.dart';

class PageSwitch extends StatefulWidget {
  const PageSwitch({super.key});

  @override
  State<PageSwitch> createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: MyAppBar(title: "popcorn 🍿"),
      body: _buildPageIndex(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.tealAccent,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.white24,
        selectedFontSize: 16,
        onTap: (value) {
          if (_currentIndex == value) {
            return;
          }
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.house_rounded,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_movies), label: "Watchlist")
        ],
      ),
    );
  }
}

Widget _buildPageIndex(int index) {
  switch (index) {
    case 0:
      return const Homepage();
    case 1:
      return const ProfilePage();
    default:
      return const Homepage();
  }
}
