import 'package:flutter/material.dart';
import 'package:neurotrainer/screens/home.dart';
import 'package:neurotrainer/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neurotrainer/screens/select_mode.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  bool isSign = false;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true
  );

  final storage = new FlutterSecureStorage(aOptions: _getAndroidOptions());

  String? access_token = await storage.read(key: "access_token", aOptions: _getAndroidOptions());

  if (access_token!.isNotEmpty) {
    isSign = true;
  }

  runApp(
    MaterialApp(
      home: isSign ? SelectModeScreen() : LoginScreen(),
      debugShowCheckedModeBanner: true,
    )
  );
}