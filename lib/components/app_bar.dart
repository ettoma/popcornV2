import 'package:flutter/material.dart';

class PopcornAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PopcornAppBar({super.key, required this.title, this.leadingButton});

  final String title;
  final bool? leadingButton;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<PopcornAppBar> createState() => _PopcornAppBarState();
}

class _PopcornAppBarState extends State<PopcornAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.leadingButton == true ? true : false,
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromRGBO(12, 19, 79, 1),
      foregroundColor: Colors.white,
    );
  }
}
