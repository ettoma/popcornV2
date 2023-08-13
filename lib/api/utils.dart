import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../global/watchlist_provider.dart';
import 'watchlist_api.dart';

class WatchlistUtils {
  bool checkIfAlreadyOnWatchlist(int movieID, BuildContext context) {
    var watchlist = context.read<WatchlistProvider>().watchlist;

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return true;
      }
    }
    return false;
  }

  num getMovieRating(int movieID, BuildContext context) {
    var watchlist = context.read<WatchlistProvider>().watchlist;

    for (var movie in watchlist) {
      if (movie.movieID == movieID) {
        return movie.userRating!;
      }
    }

    return 0;
  }
}
