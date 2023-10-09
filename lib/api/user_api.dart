import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/watchlist_provider.dart';

class UserAPI {
  // final String baseUrlProd = 'https://popcorn-server-zfqa.onrender.com';
  final String baseUrlProd = 'http://localhost:11111';

  Future<bool> addUser(String uid) async {
    var apiUrl = '$baseUrlProd/users/signup';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, String>{
          "uid": uid,
        }),
      );

      if (response.statusCode == 201) {
        var jsonBody = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var token = jsonBody["message"].toString().split("=")[1];

        prefs.setString('token', token);

        return true;
      } else if (response.statusCode != 201) {
        print(response.body);
        return false;
      }
    } catch (error) {
      rethrow;
    }
    return false;
  }

  Future<bool> createUser(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var success = await addUser(FirebaseAuth.instance.currentUser!.uid);

      if (!success) {
        return false;
      }
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    var apiUrl = '$baseUrlProd/users/login';

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: Map<String, String>.from({"Authorization": "Bearer 123456"}),
        body: jsonEncode(<String, String>{
          "uid": "uid",
        }),
      );
      WatchlistProvider().getWatchlistForUser();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }
}
