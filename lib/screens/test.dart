import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:async';


class TestScreen extends StatefulWidget {

  @override
  _TestScreenState createState() => _TestScreenState();
}


class _TestScreenState extends State<TestScreen> {

  static const platform = MethodChannel('com.bdc.neurotrainer/data');

  @override
  void initState() {
    super.initState();
    _getText();
  }

  String text = 'None';
  String num = "10";

  Stream<List<int>?> getNums() async* {
    while (true) {
      List<int> t;
      try {
        final result = await platform.invokeMethod<List<int>>('getNum');
        t = result!;
      } on PlatformException catch (e) {
        t = [];
      }
      yield t;
    }
  }


  void _getText() async {
    String t;
    try {
      final result = await platform.invokeMethod<String>('connectBluetooth');
      t = result.toString();
    } on PlatformException catch (e) {
      t = 'Failed';
    }
    setState(() {
      text = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            StreamBuilder<List<int>?>(
              stream: getNums(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator.adaptive();
                }
                if (snapshot.hasError) {
                  return Text('Error');
                } else {
                  return Center(
                    child: Text(snapshot.data.toString(), style: TextStyle(fontSize: 26),),
                  );
                }
              },
            )
          ],
        )
    );
  }
}