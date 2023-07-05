import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';
import 'package:popcorn_v2/api/models.dart';
import 'package:popcorn_v2/firebase/firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<WatchlistItem>> fetchWatchlist(String user) async {
    var watchlist = await API().getWatchlistForUser(user);

    return watchlist;
  }

  Future<Movie> fetchMovieData(String id) async {
    var movieData = await API().getMovieFromID(id);
    return movieData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // Display an error message if API call fails
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            // Display the fetched data
                            final data = snapshot.data!;
                            return ListTile(
                              title: Text(data.title),
                              subtitle: Text(data.voteAverage.toString()),
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
