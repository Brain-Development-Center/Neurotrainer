import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:neurotrainer/screens/training_video.dart';


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
      data.forEach((training) {
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
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'access': allValues['accessToken'].toString(),
          'refresh': allValues['refreshToken'].toString()
        }),
    );
    final responseData = jsonDecode(response.body);
    await storage.write(key: 'accessToken', value: responseData['result']['access_token'], aOptions: _getAndroidOptions());
    await storage.write(key: 'refreshToken', value: responseData['result']['refresh_token'], aOptions: _getAndroidOptions());
  }

  int selected_type = -1;
  int selected_training = -1;
  int selected_mode = -1;

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
                          width: width * 0.5,
                          margin: EdgeInsets.only(left: width * 0.1),
                          child: isLoaded ? ListView.builder(
                            itemCount: trainings.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(top: 14, bottom: 14, left: width * 0.02),
                                  margin: EdgeInsets.only(bottom: height * 0.01),
                                  child: Text(trainings[index], style: GoogleFonts.jost(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),),
                                  decoration: BoxDecoration(
                                    color: selected_training == index ? Color(0xFF86B0CB) : Color(0xFFDBE7EF),
                                    borderRadius: BorderRadius.only(topLeft: index == 0 ? Radius.circular(30) : Radius.circular(0), topRight: index == 0 ? Radius.circular(30) : Radius.circular(0)),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    if (selected_training == index) {
                                      selected_training = -1;
                                    } else {
                                      selected_training = index;
                                    }
                                  });
                                },
                              );
                            },
                          ) : Center(
                            child: CircularProgressIndicator(color: Color(0xFFDBE7EF)),
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(left: width * 0.02, top: height * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    trainings.sort();
                                  });
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Color(0xFF86B0CB)
                                ),
                                icon: Icon(Icons.sort_by_alpha, color: Colors.white, size: width * 0.05,),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                width: width * 0.25,
                                child: Text('Упорядочить по названию', style: GoogleFonts.jost(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01, left: width * 0.02, bottom: height * 0.01),
                      child: Text('Выбор режима:', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              width: width * 0.2,
                              height: width * 0.15,
                              decoration: BoxDecoration(
                                  color: selected_type == 0 ? Color(0xFF156499) : Color(0xFF86B0CB),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Container(
                                  height: width * 0.12,
                                  width: width * 0.12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset('assets/trainings_1.svg', width: width * 0.06, color: selected_type == 0 ? Color(0xFF156499) : Color(0xFF86B0CB),),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_type = 0;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: width * 0.2,
                              height: width * 0.15,
                              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                              decoration: BoxDecoration(
                                  color: selected_type == 1 ? Color(0xFF156499) : Color(0xFF86B0CB),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Container(
                                  height: width * 0.12,
                                  width: width * 0.12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset('assets/trainings_2.svg', width: width * 0.06, color: selected_type == 1 ? Color(0xFF156499) : Color(0xFF86B0CB),),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_type = 1;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              width: width * 0.2,
                              height: width * 0.15,
                              decoration: BoxDecoration(
                                  color: selected_type == 2 ? Color(0xFF156499) : Color(0xFF86B0CB),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Container(
                                  height: width * 0.12,
                                  width: width * 0.12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset('assets/trainings_3.svg', width: width * 0.06, color: selected_type == 2 ? Color(0xFF156499) : Color(0xFF86B0CB),),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_type = 2;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.1),
                              child: Column(
                                children: [
                                  Container(
                                    height: width * 0.1,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(
                                        color: selected_mode == 0 ? Color(0xFFABB9C2) : Color(0xFFDBE7EF),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Text('Классика', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.normal),)
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_mode = 0;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                              child: Column(
                                children: [
                                  Container(
                                    height: width * 0.1,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(
                                        color: selected_mode == 1 ? Color(0xFF77A0A4) : Color(0xFF86BCC1),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Text('70%', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.normal),)
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_mode = 1;
                              });
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: width * 0.1,
                                    width: width * 0.1,
                                    decoration: BoxDecoration(
                                        color: selected_mode == 2 ? Color(0xFF996C6C) : Color(0xFFC18686),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  Text('PRO', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.normal),)
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                selected_mode = 2;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                     child: Container(
                       margin: EdgeInsets.only(left: width * 0.1, bottom: height * 0.05),
                       alignment: Alignment.bottomLeft,
                       child: ElevatedButton(
                         child: Text('Начать тренировку', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Color(0xFF5E96BA),
                         ),
                         onPressed: () {
                           Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrainingVideoScreen(training: trainings[selected_training], trainingMode: selected_mode,)));
                         },
                       ),
                     ),
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