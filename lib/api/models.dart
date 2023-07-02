// class Movie {
//   final int id;
//   final String title;
//   final String? posterPath;
//   final num? voteAverage;

//   Movie(
//       {required this.id,
//       required this.title,
//       this.posterPath,
//       this.voteAverage});

//   factory Movie.fromJson(Map<String, dynamic> json) {
//     return Movie(
//         id: json['id'],
//         title: json['title'],
//         posterPath: json['poster_path'],
//         voteAverage: json['vote_average']);
//   }
// }

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
        title: json['title'],
        posterPath: json['poster_path'],
        voteAverage: json['vote_average'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        voteCount: json['vote_count'],
        backdropPath: json['backdrop_path']);
  }
}
