import 'watchlist_api.dart';

class WatchlistUtils {
  Future<bool> checkIfAlreadyOnWatchlist(int movieID) async {
    var watchlist = await WatchlistAPI().getWatchlistForUser();

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return true;
      }
    }
    return false;
  }

  Future<num> getMovieRating(int movieID) async {
    var watchlist = await WatchlistAPI().getWatchlistForUser();

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return movie.userRating!;
      }
    }

    return 0;
  }
}
