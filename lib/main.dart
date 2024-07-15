import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Create Facebook Campaign',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  final String accessToken = 'EAAlvKgsFbJ0BO4fRWhXdw7CzIWGNp1NdW9DElQbozoeBaqEH574rFDUfzNZBXIk8GZBZCVjTiWCtwRQCZAnZAA05X78jNGJn2R2e5vpmBWZBqbdJ5fRtb8UlmZAbGKPkQyOk0KWVjnJzNLIybLLtbSJGLOJZAfUeRmkZAS2ZC6cBt1Nilkb1VZBINGGPi9wtAZCx2kXq'; // Replace with your access token
  final String accountId = 'act_3813813875544573'; // Replace with your ad account ID
  String _response = '';

  Future<void> createCampaign() async {
    final url = 'https://graph.facebook.com/v13.0/$accountId/campaigns';
    final body = {
      'name': 'final campaign',
      'objective': 'OUTCOME_SALES',
      'status': 'PAUSED',
      'special_ad_categories': jsonEncode(["NONE", "HOUSING"]),
      'access_token': accessToken,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    setState(() {
      if (response.statusCode == 200) {
        _response = 'Campaign Created: ${response.body}';
      } else {
        _response = 'Failed to create campaign: ${response.body}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Facebook Campaign'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: createCampaign,
              child: const Text('Create the campaign'),
            ),
            const SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
