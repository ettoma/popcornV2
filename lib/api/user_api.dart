import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserAPI {
  // final String BASE_URL_PROD = 'https://popcorn-server-zfqa.onrender.com';
  final String BASE_URL_PROD = 'http://10.0.2.2:8080';

  Future<bool> addUser(String email, String password) async {
    var emailNorm = email.toLowerCase();
    emailNorm = emailNorm.trim();

    var apiUrl = '$BASE_URL_PROD/users/signup';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(
              <String, String>{"email": email, "password": password}));

      var data = json.decode(response.body);

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 404) {
        print(data["message"]);
        return false;
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
    return false;
  }

  Future<bool> createUser(String email, password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signInWithEmailPassword(String email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}
