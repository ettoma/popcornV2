import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserAPI {
  Future<bool> addUser(String email, String password) async {
    var emailNorm = email.toLowerCase();
    emailNorm = emailNorm.trim();

    var apiUrl = 'http://127.0.0.1:8080/users/signup';

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

  Future<bool> signInWithEmailPassword(String email, password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Sign-in successful.");
      print(userCredential);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }
}
