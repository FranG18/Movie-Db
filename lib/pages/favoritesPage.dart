import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_database/models/MovieDetail2.dart';
import 'package:the_movie_database/services/movieService.dart';

class favoritesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_favoritesPageState();

}

class _favoritesPageState extends State<favoritesPage> {

  movieService service;
  final String imageUrl = 'https://image.tmdb.org/t/p/w500/';
  //double _opacity=1.0;
  @override
  void initState() {
    super.initState();
    service = movieService();
  }
  
  
  Future<List<String>> _getFavoritesId() async{
    final prefs= await SharedPreferences.getInstance();
    List<String> listaPeliculas=prefs.getStringList('Peliculas');
    if(listaPeliculas==null){
      return [];
    }else{
      return listaPeliculas;
    }
  }

  Future<bool> _deleteMovie(int index) async{
    final prefs= await SharedPreferences.getInstance();
    List<String> listaPeliculas=prefs.getStringList('Peliculas');
    print(listaPeliculas[index]);
    listaPeliculas.removeAt(index);
    prefs.setStringList('Peliculas', listaPeliculas);
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _getFavoritesId(),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
                List<String> peliculasId=snapshot.data;
                print(peliculasId);
                return  ListView.builder(itemBuilder: (context,index){
                    String id=peliculasId[index];
                    return FutureBuilder(
                      future: service.getMovie(int.parse(id)),
                      builder: (context,snapshot){
                        if(snapshot.connectionState==ConnectionState.done){
                          MovieDetail2 movie=snapshot.data;
                          return Container(
                            height: 150,
                            padding: EdgeInsets.all(5),
                            child: GestureDetector(
                              child: AnimatedOpacity(
                                opacity: 0.7,
                                duration: Duration(seconds: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  elevation: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(padding:EdgeInsets.all(10),child: Image(image: NetworkImage('${imageUrl}${movie.posterPath}'),)),
                                      Text(movie.title),
                                      GestureDetector(
                                        child: Container(color: Colors.black26,padding:EdgeInsets.all(30),child: Icon(Icons.close)),
                                        onTap: (){
                                          print('Elimino');
                                          setState(() {
                                            _deleteMovie(index);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  ),
                              ),
                              onTap: (){
                                print('InfoPage');

                               // Navigator.push(context,MaterialPageRoute(builder:(context)=>infoPage('${imageUrl}${movie.posterPath}', movie.id)));
                              },
                            ),
                          );
                        }else{
                          return SizedBox();
                        }
                      },
                    );
                },
                  scrollDirection: Axis.vertical,
                  itemCount: peliculasId.length
                );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          },

        ),
    );
  }

}