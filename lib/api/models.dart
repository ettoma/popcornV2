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
  final String? overview;
  final String? releaseDate;
  final int? voteCount;
  final String? backdropPath;

  MovieFull(
      {required this.id,
      required this.title,
      this.posterPath,
      required this.voteAverage,
      this.overview,
      this.releaseDate,
      this.voteCount,
      this.backdropPath});

  factory MovieFull.fromJson(Map<String, dynamic> json) {
    return MovieFull(
        id: json['id'],
        title: json['title'],
        posterPath: json['poster_path'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        voteCount: json['vote_count'],
        backdropPath: json['backdrop_path']);
  }
}
