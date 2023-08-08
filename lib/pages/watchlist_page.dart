import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/watchlist_api.dart';
import 'package:popcorn_v2/api/models.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/main.dart';

import 'movie_page.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<WatchlistPage> {
  void navigateToMoviePage(String movieID) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoviePage(
        movieID: movieID,
        user: FirebaseAuth.instance.currentUser!.uid,
      ),
    ));
  }

  Future<List<WatchlistItem>> fetchWatchlist() async {
    var watchlist = await WatchlistAPI().getWatchlistForUser();

    return watchlist;
  }

  Future<Movie> fetchMovieData(String id) async {
    var movieData = await WatchlistAPI().getMovieFromID(id);
    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: const MyAppBar(title: "watchlist"),
      body: Center(
        child: FutureBuilder<List<WatchlistItem>>(
          future: fetchWatchlist(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  width: 75, height: 75, child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Errore: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data.isEmpty) {
                return const Center(
                  child: Text(
                    "add your first movie now",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: fetchMovieData(data[index].movieID.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                navigatorKey.currentState!
                                    .push(MaterialPageRoute(
                                  builder: (context) => MoviePage(
                                    movieID: data.id.toString(),
                                    user: currentUser,
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
                                        "${data.voteAverage} (${data.voteCount})",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Text('No data');
                          }
                        });
                  });
            } else {
              // Handle other cases
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}
