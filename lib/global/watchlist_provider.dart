import 'package:flutter/material.dart';

import '../api/models.dart';
import '../api/watchlist_api.dart';

class WatchlistProvider with ChangeNotifier {
  List<WatchlistItem> _watchlist = [];

  List<WatchlistItem> get watchlist => _watchlist;

  Future<void> getWatchlistForUser() async {
    var userWatchlist = await WatchlistAPI().getWatchlistForUser();
    _watchlist = userWatchlist;
    notifyListeners();
  }

  Future<void> addToWatchlist(int movieID, BuildContext context) async {
    await WatchlistAPI().addToWatchlist(movieID, context);
    _watchlist.add(WatchlistItem(movieID: movieID));
    notifyListeners();
  }

  Future<void> removeFromWatchlist(int movieID) async {
    await WatchlistAPI().removeFromWatchlist(movieID);
    _watchlist.removeWhere((element) => element.movieID == movieID);
    notifyListeners();
  }
}
