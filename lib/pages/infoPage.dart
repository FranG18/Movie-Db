import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_database/models/Credits.dart';
import 'package:the_movie_database/models/MovieDetail2.dart';
import 'package:the_movie_database/services/movieService.dart';

class infoPage extends StatefulWidget {
  String url;
  int id;
  infoPage(this.url, this.id) {}

  @override
  State<StatefulWidget> createState() => _infoPageState(id, url);
}

class _infoPageState  extends State<infoPage> {
  int id;
  String url;
  movieService service = new movieService();
  final String imageUrl = 'https://image.tmdb.org/t/p/w500/';


  _infoPageState(this.id, this.url) {}

  Future<String> _guardarPeliculas(String id) async{
      final prefs= await SharedPreferences.getInstance();
      if(prefs.getStringList('Peliculas')==null){
        prefs.setStringList('Peliculas',[id]);
        return 'Pelicula guardada en favoritos';
      }else{
        List<String> listaPeliculas=prefs.getStringList('Peliculas');
        for(int i=0;i<listaPeliculas.length;i++){
            if(listaPeliculas[i]==id){
              return 'Esta pelicula ya se encuentra en tus favoritos';
            }
        }
        listaPeliculas.add(id);
        prefs.setStringList('Peliculas', listaPeliculas);
        return 'Peliculas guardada en favoritos';
      }

    }

  @override
  Widget build(BuildContext context) {
    Size media=MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  FutureBuilder<MovieDetail2>(
                    future: service.getMovie(id),
                    builder: (context,snapshot){
                        if (snapshot.connectionState == ConnectionState.done) {
                          MovieDetail2 movie = snapshot.data;
                          return SizedBox(
                            height: (media.height-50)/2,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 20,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    child: Container(
                                      height: 280,
                                      padding: EdgeInsets.all(15),
                                      child: FadeInImage(
                                        image: NetworkImage('${url}'),
                                        placeholder: AssetImage('assets/jar_loading.gif'),
                                      ),
                                    ),
                                    onDoubleTap:  () {
                                      _guardarPeliculas('${movie.id}').then((mensaje){
                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              elevation: 10,
                                              backgroundColor: Colors.indigo,
                                              duration: Duration(milliseconds: 1500),
                                              content: Text(mensaje),
                                            )
                                        );
                                      });
                                    }
                                  ),
                                  Container(
                                    height: 300,
                                    width: 195,
                                    padding: EdgeInsets.all(10),
                                    child: Card(
                                      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: <Widget>[
                                            Text(movie.title,
                                                style: TextStyle(
                                                    fontSize: 20, color: Colors.black)),
                                            Divider(),
                                            Container(
                                              height: 200,
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Text(movie.overview,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white))),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }else{
                          return Center(child: CircularProgressIndicator());
                        }
                    },
                  ),
                    FutureBuilder<Credits>(
                        future: service.getMovieCredits(id),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.done){
                                Credits credits=snapshot.data;
                                 return SizedBox(
                                   height: (media.height-50)/2,
                                   child: GridView.count(
                                      scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                      crossAxisCount: 3,
                                      children: List.generate(9, (index){
                                        var actor=credits.cast[index];
                                          return SizedBox(
                                            height: 150,
                                            width: 100,
                                            child: Card(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              elevation: 30,
                                              child: Column(
                                                children: <Widget>[
                                                  Center(child: Text(actor.name,style: TextStyle(color: Colors.black,fontSize: 15),)),
                                                  Expanded(child: Image(
                                                      image: !(actor.profilePath==null) ? NetworkImage('${imageUrl}${actor.profilePath}') : NetworkImage('https://www.urbanpremises.com/assets/images/image-not-available.jpg'))),
                                                  SizedBox(height: 10,)
                                                ],
                                              ),
                                            ),
                                          );
                                      })
                                ),
                                 );
                          }else{
                           return Center(child:CircularProgressIndicator());
                          }
                        },
                    )
                ],
              ),
            ),
          )
       );
  }


}
