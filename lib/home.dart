import 'package:flutter/material.dart';
import 'package:popcorn_v2/api/api.dart';
import 'package:popcorn_v2/components/app_bar.dart';
import 'package:popcorn_v2/components/movie_tile.dart';

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
      appBar: const MyAppBar(title: 'popcorn 🍿'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
            child: Column(
          children: [
            SearchBar(
              trailing: const [Icon(Icons.search_outlined)],
              textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
              hintStyle:
                  MaterialStateProperty.all(TextStyle(color: Colors.grey[400])),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(212, 173, 252, 0.5)),
              elevation: MaterialStateProperty.all(2),
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
            SizedBox(
              height: 450,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fetchedMovies.length,
                itemBuilder: (context, index) {
                  var movie = fetchedMovies[index];

                  return MovieTile(
                      id: movie.id,
                      title: movie.title,
                      voteAverage: movie.voteAverage!,
                      posterPath: movie.posterPath ?? '');
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
