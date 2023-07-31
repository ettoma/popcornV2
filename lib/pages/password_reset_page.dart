import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/user_api.dart';
import 'package:popcorn_v2/components/app_bar.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const MyAppBar(title: "forgot password?"),
      body: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.amberAccent),
                controller: _emailController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  labelText: 'email',
                ),
              ),
              TextButton(
                  onPressed: () async {
                    var isSent =
                        await UserAPI().resetPassword(_emailController.text);
                    if (isSent) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "password reset email sent to ${_emailController.text}"),
                        backgroundColor: Colors.grey.withOpacity(0.5),
                      ));
                    }
                  },
                  child: const Text(
                    "send password reset email",
                    style: TextStyle(color: Colors.white54),
                  ))
            ],
          )),
    ));
  }
}
