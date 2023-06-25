import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  const MovieTile(
      {super.key,
      required this.title,
      required this.voteAverage,
      this.posterPath});

  final String title;
  final double voteAverage;
  final String? posterPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: 250,
      // height: 400,
      color: Colors.blueAccent,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          posterPath != null
              ? Image.network(
                  'https://image.tmdb.org/t/p/w500$posterPath',
                  fit: BoxFit.fitHeight,
                  height: 400,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error_outlined);
                  },
                )
              : Container(width: 200, height: 200, color: Colors.grey),
          LayoutBuilder(
            builder: (context, constraints) {
              double containerWidth = constraints.maxWidth;
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.grey.withOpacity(0.75),
                  width: containerWidth,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text(title), Text(voteAverage.toString())],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
