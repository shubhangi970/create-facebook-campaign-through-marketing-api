// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Create Facebook Ad Set',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final String accessToken = 'YOUR_ACCESS_TOKEN';
//   final String accountId = 'act_YOUR_AD_ACCOUNT_ID';
//   final String campaignId = 'YOUR_CAMPAIGN_ID';
//   String _response = '';
//
//   Future<void> createAdSet() async {
//     final url = 'https://graph.facebook.com/v13.0/$accountId/adsets';
//     final body = {
//       'name': 'Test Ad Set',
//       'campaign_id': campaignId,
//       'daily_budget': '5000', // budget in cents
//       'billing_event': 'IMPRESSIONS',
//       'optimization_goal': 'REACH',
//       'bid_amount': '20', // bid amount in cents
//       'targeting': jsonEncode({
//         'age_min': 18,
//         'age_max': 35,
//         'genders': [1], // 1 for male, 2 for female
//         'interests': [
//           {'id': '6003139266461', 'name': 'Movies'}
//         ],
//         'geo_locations': {
//           'countries': ['US']
//         }
//       }),
//       'status': 'PAUSED',
//       'access_token': accessToken,
//     };
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(body),
//     );
//
//     setState(() {
//       if (response.statusCode == 200) {
//         _response = 'Ad Set Created: ${response.body}';
//       } else {
//         _response = 'Failed to create ad set: ${response.body}';
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Facebook Ad Set'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: createAdSet,
//               child: const Text('Create Ad Set'),
//             ),
//             const SizedBox(height: 20),
//             Text(_response),
//           ],
//         ),
//       ),
//     );
//   }
// }
