import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../global/watchlist_provider.dart';

class UserAPI {
  final String baseUrlProd = 'https://popcorn-server-zfqa.onrender.com';

  Future<bool> addUser(String email, String password) async {
    var normalizedEmail = email.toLowerCase().trim();
    var apiUrl = '$baseUrlProd/users/signup';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, String>{
          "email": normalizedEmail,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 404) {
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
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      WatchlistProvider().getWatchlistForUser();
      // WatchlistProvider().getWatchedMovies();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
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
