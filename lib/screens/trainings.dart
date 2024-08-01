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
  Map<String, int> ids = {};

  bool isLoaded = false;

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
      final data = jsonDecode(trainingsResponse.body)['result'] as List<dynamic>;
      print(data.length);
      data.forEach((training) {
        print(training);
        if (training['isAvailable'] == true) {
          trainings.add(training['name']);
          ids[training['name']] = training['id'];
        }
      });
    }
    setState(() {
      isLoaded = true;
    });
  }


  void updateAccessToken() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true
    );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    Map<String, String> allValues = await storage.readAll(aOptions: _getAndroidOptions());
    final response = await http.post(
        Uri.parse('https://rest-cbd.tusion.xyz/v1/auth/refresh'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
          'access': allValues['accessToken']!,
          'refresh_token': allValues['refreshToken']!
        },
    );
    final responseData = jsonDecode(response.body);
    print(responseData);
    await storage.write(key: 'accessToken', value: responseData['result']['access_token'], aOptions: _getAndroidOptions());
    await storage.write(key: 'refreshToken', value: responseData['result']['refresh_token'], aOptions: _getAndroidOptions());
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
                      child: Text('Выбрать тренинг', style: GoogleFonts.jost(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.35,
                          width: width * 0.4,
                          margin: EdgeInsets.only(left: width * 0.1),
                          child: ListView.builder(
                            itemCount: trainings.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(top: 14, bottom: 14, left: width * 0.02),
                                  margin: EdgeInsets.only(bottom: height * 0.01),
                                  child: Text(trainings[index], style: GoogleFonts.jost(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFDBE7EF),
                                      borderRadius: BorderRadius.only(topLeft: index == 0 ? Radius.circular(30) : Radius.circular(0), topRight: index == 0 ? Radius.circular(30) : Radius.circular(0))
                                  ),
                                ),
                                onTap: () {},
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: width * 0.02, top: height * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: Container(
                                  child: Icon(Icons.sort_by_alpha, color: Colors.white, size: 48,),
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF86B0CB)
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    trainings.sort();
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                child: Text('Упорядочить по названию', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                              )
                            ],
                          ),
                        )
                      ],
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