class Movie {
  final int id;
  final String title;
  final String? posterPath;
  final double? voteAverage;

  Movie(
      {required this.id,
      required this.title,
      this.posterPath,
      required this.voteAverage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: json['title'],
        posterPath: json['poster_path'],
        voteAverage: json['vote_average']);
  }
}

class MovieFull {
  final int id;
  final String title;
  final String? posterPath;
  final double? voteAverage;

  MovieFull(
      {required this.id,
      required this.title,
      this.posterPath,
      required this.voteAverage});

  factory MovieFull.fromJson(Map<String, dynamic> json) {
    return MovieFull(
        id: json['id'],
        title: json['title'],
        posterPath: json['poster_path'],
        voteAverage: json['vote_average']);
  }
}
