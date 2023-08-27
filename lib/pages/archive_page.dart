import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';
import '../api/watchlist_api.dart';
import '../components/app_bar.dart';
import '../global/watchlist_provider.dart';
import '../main.dart';
import 'movie_page.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  void navigateToMoviePage(String movieID) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoviePage(
        movieID: movieID,
        user: FirebaseAuth.instance.currentUser!.uid,
      ),
    ));
  }

  Future<Movie> fetchMovieData(String id) async {
    var movieData = await WatchlistAPI().getMovieFromID(id);
    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(builder: (context, watchlist, child) {
      return SafeArea(
        child: Scaffold(
          appBar: const PopcornAppBar(title: "archive"),
          body: Center(
            child: watchlist.watchedMovies.isEmpty
                ? const Text("add your first movie now",
                    style: TextStyle(color: Colors.white))
                : ListView.builder(
                    itemCount: watchlist.watchedMovies.length,
                    itemBuilder: (context, index) {
                      var movie = watchlist.watchedMovies[index];
                      return FutureBuilder<Movie>(
                          future: fetchMovieData(movie.movieID.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              if (snapshot.hasData) {
                                final data = snapshot.data!;
                                return Dismissible(
                                  key: Key(data.id.toString()),
                                  onDismissed: (direction) =>
                                      {watchlist.removeFromWatchlist(data.id)},
                                  child: GestureDetector(
                                    onTap: () {
                                      navigatorKey.currentState!
                                          .push(MaterialPageRoute(
                                        builder: (context) => MoviePage(
                                          movieID: data.id.toString(),
                                          user: FirebaseAuth
                                              .instance.currentUser!.uid,
                                        ),
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white10,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: ListTile(
                                        leading: Text(
                                          data.title.substring(0, 1),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.amberAccent,
                                        ),
                                        title: Text(
                                          data.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rate_rounded,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              "${movie.userRating} (${data.voteAverage})",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Text("no data from the snapshot");
                              }
                            }
                          });
                    }),
          ),
        ),
      );
    });
  }
}
