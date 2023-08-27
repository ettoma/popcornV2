import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:popcorn_v2/api/models.dart';

import 'utils.dart';

class WatchlistAPI {
  // final String BASE_URL_PROD = 'https://popcorn-server-zfqa.onrender.com';
  final String BASE_URL_PROD = 'http://localhost:11111';

  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  Future<List<Movie>> getMoviesFromKeyword(String keyword) async {
    List<Movie> movies = [];

    keyword = keyword.replaceAll(' ', '%20');
    var apiUrl = '$BASE_URL_PROD/query=$keyword';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var dataJson = data["message"];

        for (var movieJson in dataJson["results"]) {
          var movie = Movie.fromJson(movieJson);
          movies.add(movie);
        }
        return movies;
      } else {
        print(response.statusCode);
        print('Request failed');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<Movie> getMovieFromID(String id) async {
    Movie movie;

    var apiUrl = '$BASE_URL_PROD/id=$id';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        movie = Movie.fromJson(data["message"]);
        movie.voteAverage =
            num.tryParse(movie.voteAverage!.toStringAsPrecision(2))!.toDouble();

        return movie;
      } else {
        print(response.statusCode);
        print('Request failed');
        return Movie(id: 0, title: "", voteAverage: 0);
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<WatchlistItem>> getWatchlistForUser() async {
    List<WatchlistItem> watchlist;

    var apiUrl = '$BASE_URL_PROD/user/watchlist';
    // var apiUrl = 'http://localhost:8080/user/watchlist';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(<String, String>{"username": currentUser}));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var dataJson = jsonDecode(data["message"]);

        if (dataJson.toString().length == 17) {
          //! hardcoded value to check if the data is {watchlist: null} Should be polished
          return List.empty();
        }
        watchlist = List<WatchlistItem>.from(
            dataJson["watchlist"].map((e) => WatchlistItem.fromJson(e)));

        return watchlist;
      } else if (response.statusCode == 404) {
        print(response.statusCode);
        return List.empty();
      } else {
        print(response.statusCode);
        return List.empty();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addToWatchlist(int movieID, BuildContext context) async {
    var apiUrl = '$BASE_URL_PROD/user/watchlist/add';

    bool isAlreadyAdded =
        WatchlistUtils().checkIfAlreadyOnWatchlist(movieID, context);

    if (!isAlreadyAdded) {
      try {
        var response = await http.put(Uri.parse(apiUrl),
            body: jsonEncode(<String, dynamic>{
              "username": FirebaseAuth.instance.currentUser!.uid,
              "movieID": movieID
            }));

        if (response.statusCode == 201) {
          return;
        } else if (response.statusCode == 404) {
          print(response.statusCode);
        } else {
          var data = jsonDecode(response.body);
          print(data);
        }
      } catch (error) {
        print(error);
        rethrow;
      }
    }
  }

  Future<void> removeFromWatchlist(int movieID) async {
    var apiUrl = '$BASE_URL_PROD/user/watchlist';

    try {
      var response = await http.delete(Uri.parse(apiUrl),
          body: jsonEncode(
              <String, dynamic>{"username": currentUser, "movieID": movieID}));

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        print(response.statusCode);
      } else {
        var data = jsonDecode(response.body);
        print(data);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> rateMovieOnWatchlist(int movieID, num rating) async {
    var apiUrl = '$BASE_URL_PROD/user/watchlist/rating';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(<String, dynamic>{
            "username": currentUser,
            "movieID": movieID,
            "rating": rating
          }));

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        print(response.statusCode);
      } else {
        var data = jsonDecode(response.body);
        print(data);
      }
    } catch (error) {
      rethrow;
    }
  }
}
