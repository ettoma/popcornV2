import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.leadingButton});

  final String title;
  final bool? leadingButton;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromRGBO(12, 19, 79, 1),
      foregroundColor: Colors.white,
    );
  }
}
