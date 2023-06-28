import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:popcorn_v2/api/models.dart';

class API {
  Future<List<Movie>> getMoviesFromKeyword(String keyword) async {
    keyword = keyword.replaceAll(' ', '%20');

    List<Movie> movies = [];

    var apiUrl =
        'https://api.themoviedb.org/3/search/movie?query=$keyword&include_adult=false&language=en-US&page=1';

    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZWRkNjUwNWQ0OTBlZjEyNWIwMzZjYjhlNzQ3YTQ1OCIsInN1YiI6IjY0NzFjNTgzYTE5OWE2MDBiZjI5NjI0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S6O7yWHWLYwOOGwpzW2GhxQJrOHxuzWvx_0NGBve21s'
      });

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

  Future<MovieFull> getMovieFromID(String id) async {
    MovieFull movie;

    var apiUrl = 'https://api.themoviedb.org/3/movie/$id';

    try {
      var response = await http.get(Uri.parse(apiUrl), headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZWRkNjUwNWQ0OTBlZjEyNWIwMzZjYjhlNzQ3YTQ1OCIsInN1YiI6IjY0NzFjNTgzYTE5OWE2MDBiZjI5NjI0NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S6O7yWHWLYwOOGwpzW2GhxQJrOHxuzWvx_0NGBve21s'
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        movie = MovieFull.fromJson(data);

        return movie;
      } else {
        print(response.statusCode);
        print('Request failed');
        return MovieFull(id: 0, title: "", voteAverage: 0);
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
