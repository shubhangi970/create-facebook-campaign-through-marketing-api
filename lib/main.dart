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
    return MaterialApp(
      title: 'Create Facebook Campaign',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String accessToken = 'EAAlvKgsFbJ0BOzqfry8NZAEX3yL9Kx6qZBesz9iK90MCNxzVZCLp7oe3YDL9U7lsrYlewc0T22NprsvyUf4O0admlJGNPOjrJ7nZBmDF2TTTnae3SdVzyzQMaetOAVOMT8d5ZA8yZBiNb1dkbeDyYY1kVCWgmR6M9hbhcFuvMJz9xkFEwvRZCfBRLH0vxyR62nQ';
  final String accountId = 'act_378334118609000';
  String _response = '';

  Future<void> createCampaign() async {
    final url = 'https://graph.facebook.com/v13.0/$accountId/campaigns';
    final body = {
      'name': 'practise1',
      'objective': 'OUTCOME_LEADS',
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
        final campaignId = jsonDecode(response.body)['id'];
        createAdSet(campaignId); // Call the function to create an ad set
      } else {
        _response = 'Failed to create campaign: ${response.body}';
      }
    });
  }

  Future<void> createAdSet(String campaignId) async {
    final url = 'https://graph.facebook.com/v13.0/$accountId/adsets';
    final body = {
      'name': 'My Ad Set',
      'campaign_id': campaignId,
      'daily_budget': '100000',
      'bid_amount': '20', // Add the bid amount
      'start_time': DateTime.now().toIso8601String(),
      'end_time': DateTime.now().add(Duration(days: 7)).toIso8601String(),
      'billing_event': 'IMPRESSIONS',
      'optimization_goal': 'LEAD_GENERATION',
      'targeting': jsonEncode({
        'geo_locations': {
          'countries': ['US'],
          // Removing cities to avoid overlap with regions
          'regions': [{'key': '4081'}], // For California, for example
        },
        'age_min': 28,
        'age_max': 58,
        'genders': [1, 2], // 1 for male, 2 for female
        'interests': [
          {'id': '6003139266461', 'name': 'Shopping and fashion'}
        ],
      }),
      'status': 'PAUSED',
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
        final adSetId = jsonDecode(response.body)['id'];
        createAdCreative(adSetId); // Call the function to create an ad creative
        _response = "Successfully created ad set.";
        print(_response);
      } else {
        _response = 'Failed to create ad set: ${response.body}';
      }
    });
  }

  Future<void> createAdCreative(String adSetId) async {
    final url = 'https://graph.facebook.com/v13.0/$accountId/adcreatives';
    final body = {
      'name': 'test - Creative',
      'object_story_spec': jsonEncode({
        'page_id': '341255639078524',
        'link_data': {
          'description': '',
          'link': 'https://rpitsolutions.com/privacy-policy/',
          'message': 'message',
          'name': 'headline',
          'call_to_action': {
            'type': 'LEARN_MORE',
            'value': {
              'link': 'https://rpitsolutions.com/privacy-policy/',
              'link_caption': ''
            }
          }
        }
      }),
      'degrees_of_freedom_spec': jsonEncode({
        'creative_features_spec': {
          'standard_enhancements': {
            'enroll_status': 'OPT_IN'
          }
        }
      }),
      'promoted_object': jsonEncode({
        'page_id': '341255639078524' // Your page ID here
      }),
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
        final adCreativeId = jsonDecode(response.body)['id'];
        createAd(adCreativeId, adSetId); // Call the function to create the ad
      } else {
        _response = 'Failed to create ad creative: ${response.body}';
      }
    });
  }


  Future<void> createAd(String adCreativeId, String adSetId) async {
    final url = 'https://graph.facebook.com/v13.0/$accountId/ads';
    final body = {
      'name': 'My Ad',
      'adset_id': adSetId,
      'creative': jsonEncode({'creative_id': adCreativeId}),
      'status': 'PAUSED',
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
        _response = 'Ad Created: ${response.body}';
      } else {
        _response = 'Failed to create ad: ${response.body}';
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
              child: const Text('Create Campaign'),
            ),
            const SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
