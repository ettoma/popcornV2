import 'package:flutter/material.dart';
import 'package:popcorn_v2/pages/archive_page.dart';
import 'package:popcorn_v2/pages/homepage.dart';
import 'package:popcorn_v2/pages/watchlist.dart';

import 'account_page.dart';

class PageSwitch extends StatefulWidget {
  PageSwitch({super.key, this.index});

  int? index;

  @override
  State<PageSwitch> createState() => _PageSwitchState();
}

class _PageSwitchState extends State<PageSwitch> {
  int _currentIndex = 0;

  Widget _buildPageIndex(int index) {
    switch (index) {
      case 0:
        return const Homepage();
      case 1:
        return const WatchlistPage();
      case 2:
        return const ArchivePage();
      case 3:
        return const AccountPage();
      default:
        return const Homepage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildPageIndex(widget.index ?? _currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.index ?? _currentIndex,
          selectedItemColor: Colors.tealAccent,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedItemColor: Colors.white24,
          selectedFontSize: 16,
          onTap: (value) {
            if (_currentIndex == value) {
              return;
            }
            widget.index = null;
            setState(() {
              _currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.house_rounded,
                ),
                label: "home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_movies), label: "watchlist"),
            BottomNavigationBarItem(
                icon: Icon(Icons.ramen_dining_rounded), label: "archive"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2), label: "profile")
          ],
        ),
      ),
    );
  }
}
