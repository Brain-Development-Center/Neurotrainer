import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:neurotrainer/screens/home.dart';
import 'package:neurotrainer/screens/login.dart';
import 'firebase_options.dart';


void main() async {

  bool isSign = false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //   if (user != null) {
  //     isSign = true;
  //   }
  // });
  runApp(
    MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: true,
    )
  );
}