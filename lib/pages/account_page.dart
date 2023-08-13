import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/components/app_bar.dart';

import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _HomepageState();
}

class _HomepageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PopcornAppBar(title: 'my account 🤖'),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Card(
              color: Colors.amberAccent,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text("Logged in as: "),
                    Text(
                      FirebaseAuth.instance.currentUser!.email!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              child: const Text(
                "log out",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            )
          ]),
        ),
      ),
    );
  }
}
