import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TrainingsScreen extends StatefulWidget {

  @override
  _TrainingsScreenState createState() => _TrainingsScreenState();
}


class _TrainingsScreenState extends State<TrainingsScreen> {

  List<String> trainings = [];

  @override
  void initState() {
    super.initState();
    getTrainings();
  }

  void getTrainings() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true
    );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    Map<String, String> allValues = await storage.readAll(aOptions: _getAndroidOptions());
    final trainingsResponse = await http.get(
      Uri.parse('https://rest-cbd.tusion.xyz/v1/franchisees/' + allValues['franchisee']! + '/trainings'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + allValues['accessToken']!
      }
    );
    if (jsonDecode(trainingsResponse.body)['code'] == 204) {
      updateAccessToken();
      getTrainings();
    } else {
      print(trainingsResponse.body);
    }
  }


  void updateAccessToken() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true
    );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    Map<String, String> allValues = await storage.readAll(aOptions: _getAndroidOptions());
    final response = await http.post(
        Uri.parse('https://rest-cbd.tusion.xyz/v1/user/login'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic> {
          'email': allValues['email'],
          'password': allValues['password'],
        })
    );
    final responseData = jsonDecode(response.body);
    print(responseData);
    await storage.write(key: 'accessToken', value: responseData['result']['access_token'], aOptions: _getAndroidOptions());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset('assets/select_profile.svg', width: width * 0.25),
                    ),
                  ],
                ),
              ),
              Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: width * 0.02, top: height * 0.02),
                        child: SvgPicture.asset('assets/select_mode_4.svg', width: width * 0.2,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05, left: width * 0.1),
                      child: Text('Выбрать тренинг', style: GoogleFonts.jost(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}