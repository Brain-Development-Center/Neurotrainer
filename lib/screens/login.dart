import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  static const platform = MethodChannel('com.bdc.neurotrainer/data');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn() async {
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: SvgPicture.asset('assets/login_logo.svg', fit: BoxFit.cover, height: height * 0.45,),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.25, right: width * 0.25, top: height * 0.05),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.white,
              style: GoogleFonts.jost(color: Colors.white),
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Логин',
                hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 18),
                filled: true,
                fillColor: Color(0XFF86B0CB),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.25, right: width * 0.25, top: height * 0.02),
            child: TextField(
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Colors.white,
              style: GoogleFonts.jost(color: Colors.white),
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Пароль',
                hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 18),
                filled: true,
                fillColor: Color(0XFF86B0CB),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          Container(
            width: width * 0.2,
            margin: EdgeInsets.only(top: height * 0.02),
            child: ElevatedButton(
              child: Text('Далее', style: GoogleFonts.jost(color: Colors.white),),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF2D3E48),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: width,
              margin: EdgeInsets.only(top: height * 0.05),
              decoration: BoxDecoration(
                color: Color(0xFF367CA9),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
              ),
              child: SvgPicture.asset('assets/login_bottom_logo.svg', fit: BoxFit.fitHeight, alignment: Alignment.topRight,)
            ),
          )
        ],
      ),
    );
  }
}