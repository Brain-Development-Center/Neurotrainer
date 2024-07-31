import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


class SelectModeScreen extends StatefulWidget {

  @override
  _SelectModeScreenState createState() => _SelectModeScreenState();
}


class _SelectModeScreenState extends State<SelectModeScreen> {

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
                      alignment: Alignment.topLeft,
                      child: SvgPicture.asset('assets/select_mode_1.svg', width: width * 0.5,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/select_mode_2.svg', width: width * 0.2,)
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/select_mode_2.svg', width: width * 0.2,)
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset('assets/select_mode_3.svg', width: width * 0.8,)
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: height,
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: SvgPicture.asset('assets/select_mode_4.svg', width: width * 0.2,),
                    ),
                    Container(
                      width: width * 0.5,
                      margin: EdgeInsets.only(top: height * 0.05),
                      child: ElevatedButton(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Свободный режим', style: GoogleFonts.jost(color: Colors.white, fontSize: 20)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF367CA9),
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16)
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      width: width * 0.5,
                      margin: EdgeInsets.only(top: height * 0.03),
                      child: ElevatedButton(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Создать профиль', style: GoogleFonts.jost(color: Colors.white, fontSize: 20)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF367CA9),
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16)
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      width: width * 0.5,
                      margin: EdgeInsets.only(top: height * 0.03),
                      child: ElevatedButton(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Выбор профиля', style: GoogleFonts.jost(color: Colors.white, fontSize: 20)),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF367CA9),
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16)
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}