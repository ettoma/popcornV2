import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/user_api.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/pages/page_switch.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool isCreated = false;
  @override
  Widget build(BuildContext context) {
    void signUp(String email, password, passwordConfirmation) async {
      if (!context.mounted) {
        return;
      }
      if (password != passwordConfirmation) {
        //TODO Implement error message
      } else if (password == passwordConfirmation) {
        var isSuccess = await UserAPI().addUser(email, password);
        void confirmAndPushPage() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("logged in as $email"),
            backgroundColor: Colors.grey.withOpacity(0.5),
          ));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => PageSwitch(
                    user: email,
                  )));
        }

        if (isSuccess) {
          confirmAndPushPage();
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: const MyAppBar(
          title: "welcome",
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  style: const TextStyle(color: Colors.amberAccent),
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white54),
                    labelText: 'email',
                  )),
              TextFormField(
                  style: const TextStyle(color: Colors.amberAccent),
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white54),
                    labelText: 'password',
                  )),
              TextFormField(
                  style: const TextStyle(color: Colors.amberAccent),
                  controller: _passwordConfirmationController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white54),
                    labelText: 'confirm password',
                  )),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.amberAccent),
                    ),
                    onPressed: () {
                      signUp(_emailController.text, _passwordController.text,
                          _passwordConfirmationController.text);
                    },
                    child: const Text(
                      "sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
