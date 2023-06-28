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
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<MovieFull>(
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
            final myData = snapshot.data!;
            return Column(
              children: [
                Text('ID: ${myData.id}'),
                Text('Name: ${myData.title}'),
                Text('Vote Avg: ${myData.voteAverage}')
              ],
            );
          } else {
            // Handle other cases
            return const Text('No data');
          }
        },
      )),
    );
  }
}
