import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeView extends StatefulWidget {
  @override
  _YouTubeViewState createState() => _YouTubeViewState();
}

class _YouTubeViewState extends State<YouTubeView> {
  List<dynamic> videos = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVideos('flutter'); // Búsqueda inicial con un término estático
  }

  Future<void> fetchVideos(String searchTerm) async {
    final apiKey = 'AIzaSyAUEXSjGvMt70kJk84TY5VnRRhX6gsdGnc'; // Reemplaza con tu API Key de YouTube
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$searchTerm&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videos = data['items'];
      });
    } else {
      throw Exception('Error al cargar los videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YouTube'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchVideos(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (BuildContext context, int index) {
                final video = videos[index]['snippet'];
                final videoId = videos[index]['id']['videoId'];
                if (videoId != null) {
                  return Column(
                    children: [
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: videoId,
                          flags: YoutubePlayerFlags(
                            autoPlay: false,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.blueAccent,
                          handleColor: Colors.blueAccent,
                        ),
                      ),
                      ListTile(
                        leading: Image.network(video['thumbnails']['default']['url']),
                        title: Text(video['title']),
                        subtitle: Text(video['channelTitle']),
                      ),
                    ],
                  );
                } else {
                  return Container(); // O muestra un widget alternativo o maneja el caso de videoId nulo según tus necesidades.
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
