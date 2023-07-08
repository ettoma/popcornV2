import 'api.dart';

class WatchlistUtils {
  Future<bool> checkIfAlreadyOnWatchlist(int movieID) async {
    var watchlist = await API().getWatchlistForUser("ettore-1234");

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return true;
      }
    }
    return false;
  }
}
