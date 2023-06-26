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

  String formatVoteAvg(double n) {
    var b = n.toStringAsPrecision(2);
    return b;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 10,
      splashColor: Colors.amberAccent,
      onPressed: () {
        print("click");
      },
      icon: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: 250,
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.greenAccent.withOpacity(0.75),
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
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.6),
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
