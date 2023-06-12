import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailsScreen extends StatefulWidget {
  final List<String> movieTitles;

  const MovieDetailsScreen({Key? key, required this.movieTitles}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<Map<String, dynamic>> _movieDetailsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future<void> _fetchMovieDetails() async {
    final apiKey = 'd7068e80'; // Reemplaza con tu propia clave de API de OMDb
    final baseUrl = 'http://www.omdbapi.com/';

    for (String movieTitle in widget.movieTitles) {
      final url = Uri.parse('$baseUrl?apikey=$apiKey&t=$movieTitle');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _movieDetailsList.add(data);
        });
      } else {
        throw Exception('Failed to fetch movie details for $movieTitle');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _movieDetailsList.length,
              itemBuilder: (context, index) {
                final movieDetails = _movieDetailsList[index];

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieDetails['Title'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.network(
                        movieDetails['Poster'],
                        height: 200,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Year: ${movieDetails['Year']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plot: ${movieDetails['Plot']}',
                        style: TextStyle(fontSize: 18),
                      ),
                      // Puedes mostrar más detalles de la película según tus necesidades
                    ],
                  ),
                );
              },
            ),
    );
  }
}
