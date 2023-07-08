import 'dart:math';

import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';
import 'package:popcorn_v2/api/models.dart';
import 'package:popcorn_v2/components/app_bar.dart';

import 'movie_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void navigateToMoviePage(String movieID) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MoviePage(movieID: movieID),
    ));
  }

  Future<List<WatchlistItem>> fetchWatchlist(String user) async {
    var watchlist = await API().getWatchlistForUser(user);

    // var watchlist = List.generate(
    //     5,
    //     (index) => WatchlistItem(
    //         movieID: Random().nextInt(99999) + 29999,
    //         userRating: 1,
    //         watched: false));
    return watchlist;
  }

  Future<Movie> fetchMovieData(String id) async {
    var movieData = await API().getMovieFromID(id);
    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "Watchlist"),
      body: Center(
        child: FutureBuilder<List<WatchlistItem>>(
          future: fetchWatchlist("ettore-1234"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display an error message if API call fails
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Display the fetched data
              final data = snapshot.data!;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: fetchMovieData(data[index].movieID.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Display a loading indicator while waiting for data
                            return const CircularProgressIndicator(
                              color: Colors.white,
                            );
                          } else if (snapshot.hasError) {
                            // Display an error message if API call fails
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            // Display the fetched data
                            final data = snapshot.data!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MoviePage(movieID: data.id.toString()),
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
                                  leading: const Icon(
                                    Icons.podcasts,
                                    color: Colors.amber,
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
                                  subtitle: Text(
                                    "${data.voteAverage} (${data.voteCount})",
                                    style: const TextStyle(color: Colors.white),
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
