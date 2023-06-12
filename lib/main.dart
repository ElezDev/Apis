import 'package:flutter/material.dart';
import 'package:gpt_filter/pages/api_nasa.dart';
import 'package:gpt_filter/pages/gpt_api.dart';
import 'package:gpt_filter/pages/poke_api.dart';
import 'package:gpt_filter/pages/movies_api.dart';
import 'package:gpt_filter/pages/youtobe_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Drawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

final List<String> movieTitles = [
  'Guardians of the Galaxy Vol. 2',
  'Avengers: Endgame',
  'Black Panther'
];

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Navigation Drawer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('PokeApi'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PokedexApp()),
                );
              },
            ),
            ListTile(
              title: Text('Movies 2'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailsScreen(movieTitles: movieTitles),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Youtobe '),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YouTubeView(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('ChatGpt'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
             ListTile(
              title: Text('Nasa'),
              onTap: () {
                Navigator.pop(context); // Cerrar el Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Nassa(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
