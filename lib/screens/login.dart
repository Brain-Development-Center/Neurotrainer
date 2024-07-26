import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn() async {
    print(emailController.text);
    print(passwordController.text);
    final response = await http.post(
      Uri.parse('https://rest-cbd.tusion.xyz/v1/user/login'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic> {
        'email': emailController.text,
        'password': passwordController.text
      })
    );
    final responseData = jsonDecode(response.body);
    print(responseData);
    if (responseData['code'] == 0) {
      AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true
      );
      final storage = new FlutterSecureStorage(aOptions: _getAndroidOptions());
      await storage.write(key: 'access_token', value: responseData['result']['access_token'], aOptions: _getAndroidOptions());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не удалось войти в аккаунт. Проверьте данные')));
    }
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
              onPressed: () {
                signIn();
              },
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