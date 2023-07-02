import 'package:flutter/material.dart';

import '../movie_page.dart';

class MovieTile extends StatelessWidget {
  const MovieTile(
      {super.key,
      required this.title,
      required this.voteAverage,
      this.posterPath,
      required this.id});

  final int id;
  final String title;
  final num voteAverage;
  final String? posterPath;

  String formatVoteAvg(num n) {
    var b = n.toStringAsPrecision(2);
    return b;
  }

  @override
  Widget build(BuildContext context) {
    void navigateToMoviePage(String movieID) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MoviePage(movieID: movieID),
      ));
    }

    return GestureDetector(
      onTap: () {
        navigateToMoviePage(id.toString());
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: 250,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: posterPath!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500$posterPath'),
                          fit: BoxFit.fill)
                      : const DecorationImage(
                          image: AssetImage("assets/no-results.png"),
                          scale: 5)),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth = constraints.maxWidth;
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromRGBO(92, 70, 156, 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: containerWidth,
                    height: 80,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: containerWidth / 2,
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(212, 173, 252, 0.5),
                          ),
                          child: Text(
                            '⭐️ ${formatVoteAvg(voteAverage)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
