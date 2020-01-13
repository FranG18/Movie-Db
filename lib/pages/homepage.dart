import 'package:flutter/material.dart';
import 'package:the_movie_database/pages/favoritesPage.dart';
import 'package:the_movie_database/pages/moviePage.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  TabController _controller;
  int _index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=TabController(length: 3,initialIndex: 0,vsync: this);
    _index=0;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('The Movie DB'),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          moviePage(),
          pruebaPage('Search'),
          favoritesPage()
          ],
        controller: _controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index){
          setState(() {
            _index=index;
            _controller.index=index;
            print(_index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
            ),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
              title: Text('Search')
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
              title: Text('Favorites')
          )
        ],
      ),
    );
  }

}


class pruebaPage extends StatelessWidget{

  String text;

  pruebaPage(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(text),
      ),
    );
  }

}

