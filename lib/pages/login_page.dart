import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/user_api.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/pages/page_switch.dart';
import 'package:popcorn_v2/pages/password_reset_page.dart';
import 'package:popcorn_v2/pages/sign_up_page.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isCreated = false;
  bool isObscured = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void confirmAndPushPage(String email) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("logged in as $email"),
        backgroundColor: Colors.grey.withOpacity(0.5),
      ));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => PageSwitch(
                user: email,
              )));
    }

    void logIn(String email, password) async {
      if (!context.mounted) {
        return;
      }

      var isLoggedIn = await UserAPI().signInWithEmailPassword(email, password);

      if (isLoggedIn) {
        confirmAndPushPage(email);
      }
    }

    return SafeArea(
        child: Scaffold(
      appBar: const MyAppBar(
        title: "welcome",
      ),
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              confirmAndPushPage(snapshot.data!.email!);
            });
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image(
                      image: AssetImage("cinema.png"),
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.amberAccent),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(color: Colors.white54),
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (!EmailValidator.validate(value!)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(color: Colors.amberAccent),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white54),
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            child: Icon(
                              isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onTap: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                        ),
                        obscureText: isObscured ? true : false,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordResetPage()));
                          },
                          child: const Text(
                            "forgot password",
                            style: TextStyle(color: Colors.white38),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.amberAccent),
                                ),
                                onPressed: () {
                                  logIn(_emailController.text,
                                      _passwordController.text);
                                },
                                child: const Text(
                                  "log in",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                                },
                                child: const Text(
                                  "sign up",
                                  style: TextStyle(color: Colors.white38),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }
          return const Text("everything else failed ☠️");
        },
      ),
    ));
  }
}
