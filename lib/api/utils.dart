import 'api.dart';

class WatchlistUtils {
  Future<bool> checkIfAlreadyOnWatchlist(int movieID, String user) async {
    var watchlist = await API().getWatchlistForUser(user);

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return true;
      }
    }
    return false;
  }
}
