import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  late Map<String, String> values;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  bool isLoaded = false;

  void getUser() async {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true
    );

    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    values = await storage.readAll(aOptions: _getAndroidOptions());
    isLoaded = true;
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
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.05, left: width * 0.1),
                          child: Icon(Icons.account_circle, color: Colors.grey, size: 60),
                        ),
                        isLoaded ? Container(
                          margin: EdgeInsets.only(top: height * 0.05, left: width * 0.02),
                          child: Text(values['name']! + ' ' + values['surname']!, style: GoogleFonts.jost(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                        ) : CircularProgressIndicator(color: Colors.black,)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05, left: width * 0.1),
                      child: Text('Информация о пройденных занятих', style: GoogleFonts.jost(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: height * 0.005),
                          height: height * 0.05,
                          width: width * 0.1,
                          margin: EdgeInsets.only(left: width * 0.1, top: height * 0.01),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('Занятие', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),),
                          ),
                        ),
                        Container(
                          width: width * 0.65,
                          height: height * 0.05,
                          color: Color(0xFFDBE7EF),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                height: height * 0.05,
                                width: width * 0.15,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('День', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                height: height * 0.05,
                                width: width * 0.15,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('Режим', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                height: height * 0.05,
                                width: width * 0.15,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('Оценка', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: height * 0.01),
                                height: height * 0.05,
                                width: width * 0.15,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('Лучшее время', style: GoogleFonts.jost(color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02, right: width * 0.15),
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        child: Text('Перейти к тренировке', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5E96BA),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}