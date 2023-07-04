import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:popcorn_v2/api/models.dart';

class API {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZWRkNjUwNWQ0OTBlZjEyNWIwMzZjYjhlNzQ3YTQ1OCIsInN1YiI6IjY0NzFjNTgzYTE5OWE2MDBiZjI5NjI0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S6O7yWHWLYwOOGwpzW2GhxQJrOHxuzWvx_0NGBve21s'
  };

  Future<List<Movie>> getMoviesFromKeyword(String keyword) async {
    List<Movie> movies = [];

    keyword = keyword.replaceAll(' ', '%20');
    var apiUrl = 'http://127.0.0.1:8080/query=$keyword';

    try {
      var response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        var results = data['results'];

        for (var movieJson in results) {
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
      var response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        movie = Movie.fromJson(data);
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
          body: jsonEncode(<String, String>{"username": "ettore-1234"}));

      if (response.statusCode == 200) {
        Iterable data = json.decode(response.body);

        watchlist = List<WatchlistItem>.from(
            data.map((e) => WatchlistItem.fromJson(e)));

        return watchlist;
      } else {
        return List.empty();
      }
    } catch (error) {
      rethrow;
    }
  }
}
