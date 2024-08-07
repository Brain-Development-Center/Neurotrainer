import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:neurotrainer/screens/home.dart';


class CreateProfileScreen extends StatefulWidget {

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}


class _CreateProfileScreenState extends State<CreateProfileScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController parentNameController = TextEditingController();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true
  );

  String? franchisee;

  @override
  void initState() {
    super.initState();
    getUser();

  }

  void getUser() async {
    final storage = new FlutterSecureStorage(aOptions: _getAndroidOptions());
    franchisee = await storage.read(key: "franchisee", aOptions: _getAndroidOptions());
  }

  int type = 0;

  void signUp() async {
    await FirebaseFirestore.instance.collection('organizations').doc(franchisee).collection('users').doc(nameController.text + ' ' + surnameController.text).set({
      'name': nameController.text,
      'surname': surnameController.text,
      'birthday': birthdayController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'query': queryController.text,
      'notes': notesController.text,
      'type': type == 0 ? 'child' : 'adult'
    });
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true
    );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: 'name', value: nameController.text, aOptions: _getAndroidOptions());
    await storage.write(key: 'surname', value: surnameController.text, aOptions: _getAndroidOptions());
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: height,
                width: width,
                child: Column(
                  children: [
                    SafeArea(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: width * 0.02, top: height * 0.02),
                        child: SvgPicture.asset('assets/select_mode_4.svg', width: width * 0.25,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/select_mode_2.svg', width: width * 0.2,),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.05),
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('assets/select_mode_2.svg', width: width * 0.2,),
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
                  children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(
                         margin: EdgeInsets.only(top: height * 0.18),
                         child: ElevatedButton(
                           child: Text('Ребенок', style: GoogleFonts.jost(color: Colors.white, fontSize: 12),),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: type == 0 ? Color(0xFF367CA9) : Color(0xFF86B0CB),
                           ),
                           onPressed: () {
                             setState(() {
                               type = 0;
                             });
                           },
                         ),
                       ),
                       Container(
                         margin: EdgeInsets.only(top: height * 0.18, left: width * 0.05),
                         child: ElevatedButton(
                           child: Text('Взрослый', style: GoogleFonts.jost(color: Colors.white, fontSize: 12),),
                           style: ElevatedButton.styleFrom(
                               backgroundColor: type == 1 ? Color(0xFF367CA9) : Color(0xFF86B0CB),
                           ),
                           onPressed: () {
                             setState(() {
                               type = 1;
                             });
                           },
                         ),
                       ),
                     ],
                   ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.02),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: type == 0 ? 'Имя ребенка' : 'Имя',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: surnameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: type == 0 ? 'Фамилия ребенка' : 'Фамилия',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                    type == 0 ?
                    Container(
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: parentNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: 'Имя родителя',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                    ) : Container(),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: birthdayController,
                        keyboardType: TextInputType.datetime,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: type == 0 ? 'Дата рождения ребенка' : 'Дата рождения',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: 'Телефон',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: 'Почта',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: queryController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                          hintText: type == 0 ? 'Жалобы/причина визита' : 'Запрос',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(left: width * 0.15, right: width * 0.15, top: height * 0.01),
                      child: TextField(
                        controller: notesController,
                        cursorColor: Colors.white,
                        style: GoogleFonts.jost(color: Colors.white),
                        maxLines: 2,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12, right: width * 0.03),
                          hintText: 'Дополнительные заметки и комментарии',
                          hintStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
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
                      margin: EdgeInsets.only(top: height * 0.02),
                      child: ElevatedButton(
                        child: Text('Создать', style: GoogleFonts.jost(color: Colors.white, fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5E96BA),
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 24, right: 24)
                        ),
                        onPressed: () {
                          signUp();
                        },
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