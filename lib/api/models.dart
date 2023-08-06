import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String? posterPath;
  num? voteAverage;
  final String? overview;
  final String? releaseDate;
  final int? voteCount;
  final String? backdropPath;

  Movie(
      {required this.id,
      required this.title,
      this.posterPath,
      required this.voteAverage,
      this.overview,
      this.releaseDate,
      this.voteCount,
      this.backdropPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: utf8.decode(json['title'].toString().codeUnits),
        posterPath: json['poster_path'],
        voteAverage: json['vote_average'],
        overview: utf8.decode(json['overview'].toString().codeUnits),
        releaseDate: json['release_date'],
        voteCount: json['vote_count'],
        backdropPath: json['backdrop_path']);
  }
}

class WatchlistItem {
  final int movieID;
  final num? userRating;
  final bool? watched;

  WatchlistItem({required this.movieID, this.userRating, this.watched});

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
        movieID: json['movieID'],
        userRating: json['userRating'],
        watched: json['watched']);
  }
}
