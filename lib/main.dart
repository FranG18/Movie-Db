import 'package:flutter/material.dart';
import 'package:the_movie_database/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(8, 50, 31 ,1),
        accentColor: Color.fromRGBO(0, 10, 0, 0.8),

        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'The movie DB',
      initialRoute:'/' ,
      routes: getApplicationRoutes(),
    );
  }
}

