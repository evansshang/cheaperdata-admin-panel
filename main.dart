import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show rootBundle; // Import for asset loading
import 'dart:convert'; // Import for json decoding

// Keep localization imports commented for now
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'app_localizations.dart'; 

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyAppIncremental5());
}

class MyAppIncremental5 extends StatefulWidget {
  @override
  _MyAppIncremental5State createState() => _MyAppIncremental5State();
}

class _MyAppIncremental5State extends State<MyAppIncremental5> {
  String _assetContent = 'Loading asset...';
  bool _assetLoaded = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  Future<void> _loadAsset() async {
    try {
      // Directly load the en.json asset
      final String jsonString = await rootBundle.loadString('assets/lang/en.json');
      // Try decoding to ensure it's valid JSON
      json.decode(jsonString);
      setState(() {
        _assetContent = 'Asset assets/lang/en.json loaded and decoded successfully!';
        _assetLoaded = true;
      });
    } catch (e) {
      print('Error loading asset: $e');
      setState(() {
        _assetContent = 'Failed to load asset assets/lang/en.json.';
        _errorMessage = e.toString();
        _assetLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Basic MaterialApp without localization delegates
    return MaterialApp(
      title: 'CheaperData - Step 6 (Asset Load Test)',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Asset Loading Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_assetContent),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error: $_errorMessage', style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
