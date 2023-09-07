import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/user_api.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/global/watchlist_provider.dart';
import 'package:popcorn_v2/main.dart';
import 'package:popcorn_v2/pages/page_switch.dart';
import 'package:popcorn_v2/pages/password_reset_page.dart';
import 'package:popcorn_v2/pages/sign_up_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

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

  bool isUsernameError = false;
  bool isPasswordError = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    void confirmAndPushPage() async {
      await context.read<WatchlistProvider>().getWatchlistForUser();

      Navigator.of(navigatorKey.currentContext!).pushReplacement(
          MaterialPageRoute(builder: (context) => PageSwitch()));
    }

    void logInWithEmail(String email, String password) async {
      if (!context.mounted) {
        return;
      }

      bool isValid = loginFormKey.currentState!.validate();

      if (!isValid) {
        return;
      }

      var isLoggedIn = await UserAPI().signInWithEmailPassword(email, password);

      if (!isLoggedIn) {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          content: Text("Email or password is incorrect"),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
        ));
        return;
      }

      if (isLoggedIn) {
        confirmAndPushPage();
      }
    }

    return SafeArea(
        child: Scaffold(
      appBar: const PopcornAppBar(
        title: "welcome",
      ),
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              confirmAndPushPage();
            });
          } else {
            return Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.notes_rounded,
                      size: 150.00,
                      color: Colors.white,
                    ),
                  ),
                  Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.amberAccent),
                          controller: _emailController,
                          autofillHints: const [AutofillHints.email],
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                            labelStyle: TextStyle(color: Colors.white70),
                            labelText: 'Username',
                          ),
                          validator: (username) => username != null &&
                                  !EmailValidator.validate(username)
                              ? "Enter a valid email"
                              : null,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.amberAccent),
                          controller: _passwordController,
                          validator: (password) =>
                              password != null && password.length < 6
                                  ? "Enter a valid password"
                                  : null,
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                            labelStyle: const TextStyle(color: Colors.white70),
                            labelText: 'Password',
                            suffixIcon: GestureDetector(
                              child: Icon(
                                isObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
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
                              style: TextStyle(color: Colors.white54),
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
                                    logInWithEmail(_emailController.text,
                                        _passwordController.text);
                                  },
                                  child: const Text(
                                    "log in",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage()));
                                  },
                                  child: const Text(
                                    "sign up",
                                    style: TextStyle(color: Colors.white54),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
              color: Colors.amberAccent,
              strokeCap: StrokeCap.round,
            ),
          );
        },
      ),
    ));
  }
}
