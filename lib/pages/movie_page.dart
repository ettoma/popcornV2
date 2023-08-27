import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/watchlist_api.dart';
import 'package:popcorn_v2/api/utils.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/global/watchlist_provider.dart';
import 'package:popcorn_v2/main.dart';
import 'package:popcorn_v2/pages/page_switch.dart';
import 'package:provider/provider.dart';

import '../api/models.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.movieID, required this.user});

  final String movieID;
  final String user;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  bool isAlreadyOnWatchlist = false;

  Future<num> fetchMovieUserRating(String id) async {
    var rating = WatchlistUtils().getMovieRating(int.parse(id), context);

    return rating;
  }

  @override
  Widget build(BuildContext context) {
    void removeFromWatchlist(int movieID) async {
      await context.read<WatchlistProvider>().removeFromWatchlist(movieID);
      setState(() {
        isAlreadyOnWatchlist = false;
      });
    }

    Future<Movie> fetchMovieData(String id) async {
      isAlreadyOnWatchlist = WatchlistUtils()
          .checkIfAlreadyOnWatchlist(int.parse(widget.movieID), context);

      var movieData = await WatchlistAPI().getMovieFromID(id);
      return movieData;
    }

    void addToWatchlist(int movieID) async {
      await context.read<WatchlistProvider>().addToWatchlist(movieID, context);
      setState(() {
        isAlreadyOnWatchlist = true;
      });
    }

    void rateMovie(int movieID) async {
      TextEditingController ratingController = TextEditingController();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: AlertDialog(
                title: const Text(
                  "Rate this movie",
                  style: TextStyle(color: Colors.white),
                ),
                content: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ratingController,
                  style: const TextStyle(
                      color: Colors.amberAccent, fontWeight: FontWeight.bold),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("cancel")),
                  TextButton(
                      onPressed: () async {
                        double? rating = double.tryParse(ratingController.text);

                        switch (rating) {
                          case null:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                      title: Text(
                                    "Enter a valid rating",
                                    style: TextStyle(color: Colors.white),
                                  ));
                                });

                          case > 10:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                      title: Text(
                                    "Enter a rating between 1 and 10",
                                    style: TextStyle(color: Colors.white),
                                  ));
                                });
                            return;
                          case <= 0:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                      title: Text(
                                    "Enter a rating between 1 and 10",
                                    style: TextStyle(color: Colors.white),
                                  ));
                                });
                            return;
                          case <= 10:
                            await context
                                .read<WatchlistProvider>()
                                .rateMovieOnWatchlist(movieID, rating);
                            navigatorKey.currentState!
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => PageSwitch(
                                          index: 2,
                                        )));
                            scaffoldMessengerKey.currentState!.showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Rating added: ${rating.toString()}")));

                          default:
                            return;
                        }
                      },
                      child: const Text("ok"))
                ],
              ),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Movie>(
          future: fetchMovieData(widget.movieID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const Center(
                  child: SizedBox(
                height: 75,
                width: 75,
                child: CircularProgressIndicator(),
              ));
            } else if (snapshot.hasError) {
              // Display an error message if API call fails
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Display the fetched data
              final data = snapshot.data!;
              return Scaffold(
                appBar: PopcornAppBar(
                  title: data.title,
                  leadingButton: true,
                ),
                body: SingleChildScrollView(
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
                                    fit: BoxFit.fitHeight)
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
                            padding: const EdgeInsets.all(20),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        child: IconButton(
                                          onPressed: () {
                                            if (isAlreadyOnWatchlist) {
                                              removeFromWatchlist(
                                                  int.parse(widget.movieID));
                                            } else {
                                              addToWatchlist(
                                                  int.parse(widget.movieID));
                                            }
                                          },
                                          icon: isAlreadyOnWatchlist
                                              ? const Icon(
                                                  Icons.check,
                                                )
                                              : const Icon(
                                                  Icons.add,
                                                ),
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        "watchlist",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                            '${data.voteAverage} (${data.voteCount})',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const Icon(Icons.star_rate_rounded,
                                          size: 21, color: Colors.white),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                            data.releaseDate != ''
                                                ? '${data.releaseDate?.substring(0, 4)}'
                                                : 'n/a',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const Text(
                                        "Year",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            rateMovie(
                                                int.parse(widget.movieID));
                                          },
                                          icon: const Icon(Icons.note_alt,
                                              color: Colors.white)),
                                      const Text(
                                        "rate",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                  // Column(
                                  //   children: [
                                  //     FutureBuilder(
                                  //         future: fetchMovieUserRating(
                                  //             widget.movieID),
                                  //         builder: (context, snapshot) {
                                  //           if (snapshot.connectionState ==
                                  //               ConnectionState.waiting) {
                                  //             // Display a loading indicator while waiting for data
                                  //             return const Center(
                                  //                 child: SizedBox(
                                  //               height: 75,
                                  //               width: 75,
                                  //               child:
                                  //                   CircularProgressIndicator(),
                                  //             ));
                                  //           } else if (snapshot.hasError) {
                                  //             // Display an error message if API call fails
                                  //             return Text(
                                  //                 'Error: ${snapshot.error}');
                                  //           } else if (snapshot.hasData) {
                                  //             // Display the fetched data
                                  //             final data = snapshot.data!;
                                  //             if (data == 0) {
                                  //               return IconButton(
                                  //                 onPressed: () {
                                  //                   rateMovie(int.parse(
                                  //                       widget.movieID));
                                  //                 },
                                  //                 icon: const Icon(Icons
                                  //                     .onetwothree_rounded),
                                  //                 color: Colors.white38,
                                  //               );
                                  //             } else {
                                  //               return GestureDetector(
                                  //                 onTap: () {
                                  //                   rateMovie(int.parse(
                                  //                       widget.movieID));
                                  //                 },
                                  //                 child: Text(
                                  //                   data.toString(),
                                  //                   style: const TextStyle(
                                  //                       color:
                                  //                           Colors.amberAccent,
                                  //                       fontWeight:
                                  //                           FontWeight.bold),
                                  //                 ),
                                  //               );
                                  //             }
                                  //           }
                                  //           return const Text("error");
                                  //         }),
                                  //     const Text(
                                  //       "my rating",
                                  //       style: TextStyle(color: Colors.white),
                                  //     )
                                  //   ],
                                  // ),
                                ]),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
              );
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
