import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';
import 'package:popcorn_v2/components/movieTileComponent.dart';

import 'api/models.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';

  List<Movie> fetchedMovies = [];

  void fetchMoviesFromKeyword(String searchQuery) async {
    var data = await API().getMoviesFromKeyword(searchQuery);

    setState(() {
      fetchedMovies = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('popcorn 🍿'),
      ),
      body: Center(
          child: Column(
        children: [
          SearchBar(
            trailing: const [Icon(Icons.search_outlined)],
            elevation: MaterialStateProperty.all(1),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20)),
            hintText: 'look for a movie',
            controller: _searchController,
            onChanged: (value) {
              if (_searchController.text.length > 3) {
                fetchMoviesFromKeyword(_searchController.text);
              }
              if (_searchController.text.isEmpty) {
                setState(() {
                  fetchedMovies.clear();
                });
              }
            },
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: fetchedMovies.length,
              itemBuilder: (context, index) {
                var movie = fetchedMovies[index];

                return MovieTile(
                    title: movie.title,
                    voteAverage: movie.voteAverage ?? 0,
                    posterPath: movie.posterPath ?? '');
              },
            ),
          )
        ],
      )),
    );
  }
}
