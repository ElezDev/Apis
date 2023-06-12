import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PokedexScreen(),
    );
  }
}

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({Key? key}) : super(key: key);

  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late List<dynamic> _pokemonList;
  late List<dynamic> _abilitiesList;
  List<bool> _isExpandedList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchPokemonList() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];

      setState(() {
        _pokemonList = results;
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _fetchAbilities() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/ability'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'];

      setState(() {
        _abilitiesList = results;
        _isExpandedList = List.generate(results.length, (_) => false);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    await _fetchPokemonList();
    await _fetchAbilities();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pokemonList.length,
              itemBuilder: (BuildContext context, int index) {
                final pokemon = _pokemonList[index];
                final name = pokemon['name'];
                final url = pokemon['url'];
                final id = url.split('/').elementAt(url.split('/').length - 2);
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                leading: Image.network(
                                  imageUrl,
                                  width: 200,
                                  height: 200,
                                ),
                                title: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text('Ver mas...'),
                                onTap: () {
                                  setState(() {
                                    _isExpandedList[index] =
                                        !_isExpandedList[index];
                                  });
                                },
                              ),
                              if (_isExpandedList[index])
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          'Habilidades:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign
                                              .center, // Alinea el texto al centro
                                        ),
                                      ),
                                      GridView.count(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        crossAxisCount:
                                            3, // Número de columnas en la rejilla
                                        children: List.generate(
                                            _abilitiesList.length, (index) {
                                          final ability = _abilitiesList[index];
                                          final abilityName = ability['name'];
                                          final abilityUrl = ability['url'];
                                          final abilityId = abilityUrl
                                              .split('/')
                                              .elementAt(
                                                  abilityUrl.split('/').length -
                                                      2);

                                          return ListTile(
                                            title: Text(abilityName),
                                            subtitle: Text('N°: $abilityId'),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
