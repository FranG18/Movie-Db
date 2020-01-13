import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:the_movie_database/models/Movie.dart';
import 'package:the_movie_database/pages/infoPage.dart';
import 'package:the_movie_database/services/movieService.dart';

class moviePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _moviePageState();
}

class _moviePageState extends State<moviePage> {
  final String imageUrl = 'https://image.tmdb.org/t/p/w500/';
  int tag=0;
  movieService service;
  List<Movie> listaPeliculas;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = movieService();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              getScrollMovies('Peliculas en cartelera',
                  service.getNowPlayingMovies('1')),
              getScrollMovies(
                  'Peliculas populares', service.getPopularMovies('1')),
              getScrollMovies(
                  'Peliculas mejor rankeadas', service.getRatedMovies('1')),
              getScrollMovies('Proximamente', service.getUpcomingMovies('1'))
            ],
          ),
        ),
      ),
    );
  }

  Widget getScrollMovies(String title, Future future) {
    return Container(
      child: Column(
        children: <Widget>[
          Align(
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            alignment: Alignment.bottomLeft,
          ),
          Divider(height: 10),
          FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              listaPeliculas = snapshot.data;
              return Container(
                height: 160,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    Movie movie = listaPeliculas[index];
                    return Hero(
                        tag:tag++,
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage('${imageUrl}${movie.posterPath}'))),
                            height: 180,
                            width: 110,
                          ),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>infoPage('${imageUrl}${movie.posterPath}', movie.id)));
                          },
                        ));
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: (listaPeliculas == null) ? 0 : listaPeliculas.length,
                ),
              );
            },
          ),
          Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
