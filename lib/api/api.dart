import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:popcorn_v2/api/models.dart';

class API {
  Future<List<Movie>> getMoviesFromKeyword(String keyword) async {
    List<Movie> movies = [];

    keyword = keyword.replaceAll(' ', '%20');
    var apiUrl = 'http://127.0.0.1:8080/query=$keyword';

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
      rethrow;
    }
  }

  Future<Movie> getMovieFromID(String id) async {
    Movie movie;

    var apiUrl = 'http://127.0.0.1:8080/id=$id';

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

  Future<List<WatchlistItem>> getWatchlistForUser(String user) async {
    List<WatchlistItem> watchlist;

    var apiUrl = 'http://127.0.0.1:8080/user/watchlist';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(<String, String>{"username": user}));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var dataJson = jsonDecode(data["message"]);

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

  Future<void> addToWatchlist(int movieID, String user) async {
    var apiUrl = 'http://127.0.0.1:8080/user/watchlist/add';

    print("we are here, user $user");

    // bool isAlreadyAdded =
    //     await WatchlistUtils().checkIfAlreadyOnWatchlist(movieID, user);

    // if (!isAlreadyAdded) {
    try {
      print("now here");
      var response = await http.put(Uri.parse(apiUrl),
          body: jsonEncode(
              <String, dynamic>{"username": user, "movieID": movieID}));
      print(response.statusCode);
      print(response.body);

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
    // }
  }

  Future<void> removeFromWatchlist(int movieID, String user) async {
    var apiUrl = 'http://127.0.0.1:8080/user/watchlist';

    try {
      var response = await http.delete(Uri.parse(apiUrl),
          body: jsonEncode(
              <String, dynamic>{"username": user, "movieID": movieID}));

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
