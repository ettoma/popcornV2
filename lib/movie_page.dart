import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';

import 'api/models.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key, required this.movieID});

  final String movieID;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  Future<MovieFull> fetchMovieData(String id) async {
    var movieData = await API().getMovieFromID(id);
    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieFull>(
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
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${data.posterPath}',
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 400,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(25),
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${data.id}'),
                          Text('Name: ${data.title}'),
                          Text('Vote Avg: ${data.voteAverage}'),
                          Text('Vote Count: ${data.voteCount}'),
                          Text('Overview: ${data.overview}')
                        ],
                      ),
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
