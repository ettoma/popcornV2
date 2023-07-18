import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/user_api.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/pages/page_switch.dart';

class UserAuthenticationPage extends StatefulWidget {
  const UserAuthenticationPage({super.key});

  @override
  State<UserAuthenticationPage> createState() => _UserAuthenticationPageState();
}

class _UserAuthenticationPageState extends State<UserAuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isCreated = false;
  @override
  Widget build(BuildContext context) {
    void addUser(String email, String password) async {
      var success = await UserAPI().addUser(email, password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(success.toString())));
    }

    void logIn(String email, password) async {
      var isLoggedIn = await UserAPI().signInWithEmailPassword(email, password);

      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PageSwitch(
                  user: email,
                )));
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(
          title: "welcome",
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.amberAccent),
                controller: _emailController,
              ),
              TextField(
                style: const TextStyle(color: Colors.amberAccent),
                controller: _passwordController,
              ),
              ElevatedButton(
                  onPressed: () {
                    logIn(_emailController.text, _passwordController.text);
                    // addUser(_emailController.text, _passwordController.text);
                  },
                  child: const Text("log in")),
            ],
          ),
        ),
      ),
    );
  }
}
