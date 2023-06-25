import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/firebase/firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Stream<QuerySnapshot> users = FirestoreAPI().getWatchlistForUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: users,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("error loading the data");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("loading");
            }
            final data = snapshot.requireData;

            return ListView(
                children: data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return ListTile(
                title: Text(data["watchlist"][0]["movieID"].toString()),
                subtitle: Text(data["watchlist"][0]["watched"].toString()),
              );
            }).toList());
          },
        ),
      ),
    );
  }
}
