import 'package:flutter/material.dart';

import '../api/models.dart';
import '../api/watchlist_api.dart';

class WatchlistProvider with ChangeNotifier {
  final List<WatchlistItem> _watchlist = [];

  List<WatchlistItem> get watchlist => _watchlist;

  void getWatchlist(String user) async {
    _watchlist.clear();
    var userWatchlist = await WatchlistAPI().getWatchlistForUser();
    _watchlist.addAll(userWatchlist);
    notifyListeners();
  }

  void addToWatchlist(WatchlistItem movie) {
    _watchlist.add(movie);
    notifyListeners();
  }

  void removeFromWatchlist(WatchlistItem movie) {
    _watchlist.remove(movie);
    notifyListeners();
  }

  bool isAlreadyOnWatchlist(int movieID) {
    return _watchlist.any((movie) => movie.movieID == movieID);
  }
}
