import 'package:flutter/material.dart';
import 'package:popcorn_v2/pages/homepage.dart';
import 'package:popcorn_v2/pages/watchlist_page.dart';

class PageSwitch extends StatefulWidget {
  const PageSwitch({super.key, required this.user});
  final String user;

  @override
  State<PageSwitch> createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int _currentIndex = 0;

  Widget _buildPageIndex(int index, String user) {
    print(user);
    switch (index) {
      case 0:
        return Homepage(
          user: widget.user,
        );
      case 1:
        return ProfilePage(user: user);
      default:
        return Homepage(
          user: widget.user,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageIndex(_currentIndex, widget.user),
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
