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
        appBar: const MyAppBar(title: 'my account 🤖'),
        body: Column(children: [
          IconButton(
            onPressed: () async {
              // print(await FirebaseAuth.instance.currentUser!
              //     .getIdTokenResult(true));
              // await FirebaseAuth.instance.currentUser!
              //     .updateDisplayName("my name");
              // print(FirebaseAuth.instance.currentUser?.displayName);
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: Icon(Icons.logout_rounded),
            color: Colors.white,
          )
        ]),
      ),
    );
  }
}
