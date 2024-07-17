import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatefulWidget {

  final User? user;

  HomeScreen({Key? key, this.user}): super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState(user: user);
}


class _HomeScreenState extends State<HomeScreen> {

  final User? user;

  _HomeScreenState({Key? key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(user!.uid),
      ),
    );
  }
}