import 'package:flutter/material.dart';

import '../api/models.dart';
import '../api/watchlist_api.dart';

class WatchlistProvider with ChangeNotifier {
  List<WatchlistItem> _watchlist = [];
  List<WatchlistItem> _watchedMovies = [];
  List<WatchlistItem> _moviesToWatch = [];

  List<WatchlistItem> get watchlist => _watchlist;
  List<WatchlistItem> get watchedMovies => _watchedMovies;
  List<WatchlistItem> get moviesToWatch => _moviesToWatch;

  Future<void> updateAllMovies() async {
    List<WatchlistItem> newWatchedMovies = [];
    List<WatchlistItem> newMoviesToWatch = [];

    for (var movie in _watchlist) {
      if (movie.watched == true) {
        newWatchedMovies.add(movie);
      } else {
        newMoviesToWatch.add(movie);
      }
    }

    _watchedMovies = newWatchedMovies;
    _moviesToWatch = newMoviesToWatch;

    notifyListeners();
  }

  Future<void> getWatchlistForUser() async {
    var userWatchlist = await WatchlistAPI().getWatchlistForUser();
    _watchlist = userWatchlist;

    await updateAllMovies();
    notifyListeners();
  }

  Future<void> addToWatchlist(int movieID, BuildContext context) async {
    await WatchlistAPI().addToWatchlist(movieID, context);
    _watchlist.add(WatchlistItem(movieID: movieID));
    await updateAllMovies();
    notifyListeners();
  }

  Future<void> removeFromWatchlist(int movieID) async {
    await WatchlistAPI().removeFromWatchlist(movieID);
    _watchlist.removeWhere((element) => element.movieID == movieID);
    await updateAllMovies();
    notifyListeners();
  }
}
