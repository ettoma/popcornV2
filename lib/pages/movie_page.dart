import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';
import 'package:popcorn_v2/api/utils.dart';
import 'package:popcorn_v2/components/app_bar.dart';

import '../api/models.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.movieID});

  final String movieID;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool isAlreadyOnWatchlist = false;
  Future<Movie> fetchMovieData(String id) async {
    var movieData = await API().getMovieFromID(id);
    isAlreadyOnWatchlist = await WatchlistUtils()
        .checkIfAlreadyOnWatchlist(int.parse(widget.movieID));

    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    void removeFromWatchlist(String user, int movieID) async {
      await API().removeFromWatchlist(movieID, user);
      setState(() {
        isAlreadyOnWatchlist = false;
      });
    }

    void addToWatchlist(String user, int movieID) async {
      await API().addToWatchlist(movieID, user);
      setState(() {
        isAlreadyOnWatchlist = true;
      });
    }

    return FutureBuilder<Movie>(
      future: fetchMovieData(widget.movieID),
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
          return Scaffold(
            floatingActionButton: isAlreadyOnWatchlist
                ? FloatingActionButton.small(
                    onPressed: () {
                      removeFromWatchlist(
                          "ettore-1234", int.parse(widget.movieID));
                      setState(() {
                        isAlreadyOnWatchlist = false;
                      });
                    },
                    child: const Icon(Icons.check),
                  )
                : FloatingActionButton.small(
                    onPressed: () {
                      addToWatchlist("ettore-1234", int.parse(widget.movieID));
                      setState(() {
                        isAlreadyOnWatchlist = true;
                      });
                    },
                    child: const Icon(Icons.add)),
            appBar: MyAppBar(title: data.title),
            body: SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  children: [
                    Container(
                      height: 500,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: data.posterPath!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${data.posterPath}'),
                                  fit: BoxFit.fill)
                              : const DecorationImage(
                                  image: AssetImage("assets/no-results.png"),
                                  scale: 5)),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.star_rate_rounded,
                                          color: Colors.amberAccent),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                          '${data.voteAverage} (${data.voteCount})',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  data.releaseDate != ''
                                      ? Text(
                                          'Year: ${data.releaseDate?.substring(0, 4)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text('Year: n/a',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Text('${data.overview}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // Handle other cases
          return const Text('No data');
        }
      },
    );
  }
}
