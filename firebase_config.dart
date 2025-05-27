import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:io';

class FirebaseConfig {
  static Future<FirebaseOptions> getOptions() async {
    // Read the Firebase configuration from the JSON file
    final configFile = File('/home/ubuntu/cheaperdata/implementation/firebase_config/firebase_options.json');
    final jsonString = await configFile.readAsString();
    final Map<String, dynamic> config = json.decode(jsonString);
    
    return FirebaseOptions(
      apiKey: config['apiKey'],
      authDomain: config['authDomain'],
      projectId: config['projectId'],
      storageBucket: config['storageBucket'],
      messagingSenderId: config['messagingSenderId'],
      appId: config['appId'],
      measurementId: config['measurementId'],
    );
  }
}
