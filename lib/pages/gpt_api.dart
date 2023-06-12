import 'package:flutter/material.dart';
import 'package:gpt_filter/controllers/gpt.dart';



class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _queryController = TextEditingController();
  String _result = '';

  void _search() async {
    final query = _queryController.text;
    if (query.isNotEmpty) {
      try {
        final response = await ApiService.sendRequest(query);
        setState(() {
          _result = response;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT Buscador'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              labelText: 'Ingrese su consulta',
            ),
          ),
          ElevatedButton(
            onPressed: _search,
            child: Text('Buscar'),
          ),
          SizedBox(height: 20),
          Text(
            'Resultado:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(_result),
        ],
      ),
    );
  }
}
