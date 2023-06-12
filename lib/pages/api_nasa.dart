import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class NasaImage {
  final String title;
  final String imageUrl;

  NasaImage({required this.title, required this.imageUrl});
}

class NasaApiService {
  static Future<List<NasaImage>> fetchImages() async {
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=gFfXNFeA0daivbi299yx1jDafQcXrCsnzZA1hSff');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData is Map) {
        final nasaImage = NasaImage(
          title: jsonData['title'],
          imageUrl: jsonData['url'],
        );

        return [nasaImage];
      }
    }

    return [];
  }
}

class Nassa extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Nassa> {
  List<NasaImage> nasaImages = [];

  @override
  void initState() {
    super.initState();
    fetchNasaImages();
  }

  void fetchNasaImages() async {
    final images = await NasaApiService.fetchImages();
    setState(() {
      nasaImages = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('NASA API Demo'),
        ),
        body: ListView.builder(
          itemCount: nasaImages.length,
          itemBuilder: (context, index) {
            final image = nasaImages[index];
            return Column(
              children: [
                Image.network(image.imageUrl),
                Text(image.title),
              ],
            );
          },
        ),
      ),
    );
  }
}
