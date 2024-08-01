import 'package:flutter/material.dart';
import 'package:neurotrainer/firebase_options.dart';
import 'package:neurotrainer/screens/create_profile.dart';
import 'package:neurotrainer/screens/home.dart';
import 'package:neurotrainer/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neurotrainer/screens/select_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/select_profile.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  bool isSign = false;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true
  );

  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  Map<String, String> allValues = await storage.readAll(aOptions: _getAndroidOptions());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MaterialApp(
      home: allValues['name'] != null ? HomeScreen() : (allValues['accessToken'] != null ? SelectModeScreen() : LoginScreen()),
      debugShowCheckedModeBanner: true,
    )
  );
}