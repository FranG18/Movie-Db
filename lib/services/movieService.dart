

import 'dart:convert';
import 'package:the_movie_database/models/Credits.dart';
import 'package:the_movie_database/models/Movie.dart';
import 'package:http/http.dart' as http;
import 'package:the_movie_database/models/MovieDetail2.dart';

class movieService{

  final String _url='https://api.themoviedb.org/3/movie/';
  final String _apiKey='?api_key=008fb3ee623e511870e6cfa8f635d29c';
  final String _language='language=en-US';

  Future<MovieDetail2> getMovie(int id) async{
    final String request='$_url$id$_apiKey&$_language';
    final response=await http.get(request);

    return movieDetail2FromJson(response.body);
  }

  Future<Credits> getMovieCredits(int id) async{
      final String request='$_url${id}/credits${_apiKey}';
      final response=await http.get(request);
      print(request);
      return creditsFromJson(response.body);
  }

  Future<List<Movie>> getPopularMovies(String page) async{
    final String request='${_url}popular${_apiKey}&${_language}&page=${page}';

    return getMovies(request);
  }

  Future<List<Movie>> getNowPlayingMovies(String page) async{
    final String request='${_url}now_playing${_apiKey}&${_language}&page=${page}';
    
    return(getMovies(request));
  }

  Future<List<Movie>> getRatedMovies(String page) async{
    final String request='${_url}top_rated${_apiKey}&${_language}&page=${page}';

    return(getMovies(request));
  }

  Future<List<Movie>> getUpcomingMovies(String page) async{
    final String request='${_url}upcoming${_apiKey}&${_language}&page=${page}';

    return(getMovies(request));
  }
  
  Future<List<Movie>> getMovies(String requestUrl) async{
      String request=requestUrl;
      final response=await http.get(request);
      List<dynamic> movieResponse=jsonDecode(response.body)['results'];
      List<Movie> listaPeliculas=new List<Movie>();

      for(int i=0;i<movieResponse.length;i++){
        listaPeliculas.add(Movie.fromJson(movieResponse[i]));
      }
      
      return listaPeliculas;
  }
}