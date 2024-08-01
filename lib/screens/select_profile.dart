import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neurotrainer/screens/home.dart';


class SelectProfileScreen extends StatefulWidget {
  
  @override
  _SelectProfileScreenState createState() => _SelectProfileScreenState();
}


class _SelectProfileScreenState extends State<SelectProfileScreen> {

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true
  );

  String? franchisee;

  int type = 0;

  List<Map<String, String>> people = [];

  bool isLoaded = false;

  void getUsers() async {
    final storage = new FlutterSecureStorage(aOptions: _getAndroidOptions());
    franchisee = await storage.read(key: "franchisee", aOptions: _getAndroidOptions());
    final snapshot = await FirebaseFirestore.instance.collection('organizations').doc(franchisee).collection('users').get();
    snapshot.docs.forEach((snapshot) {
      Map<String, String> person = {
        'name': snapshot.data()['name'],
        'surname': snapshot.data()['surname']
      };
      people.add(person);
    });
    isLoaded = true;
  }

  int selectedProfile = -1;

  void selectProfile() async {
    if (selectedProfile == -1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Вы не выбрали профиль')));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Выбор профиля', style: GoogleFonts.jost(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
            content: Text('Вы выбрали следующий профиль: ' + people[selectedProfile]['name']! + ' ' + people[selectedProfile]['surname']!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Назад', style: GoogleFonts.jost(color: Color(0xFF367CA9)),),
              ),
              TextButton(
                onPressed: () async {
                  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
                  await storage.write(key: 'name', value: people[selectedProfile]['name'], aOptions: _getAndroidOptions());
                  await storage.write(key: 'surname', value: people[selectedProfile]['surname'], aOptions: _getAndroidOptions());
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text('Далее', style: GoogleFonts.jost(color: Color(0xFF367CA9)),),
              ),
            ],
          );
        }
      );
    }
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
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: height * 0.1, left: width * 0.2),
                      child: Text('Выбор профиля:', style: GoogleFonts.jost(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02, left: width * 0.3),
                          child: ElevatedButton(
                            child: Text('Ребенок', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
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
                          margin: EdgeInsets.only(top: height * 0.02, right: width * 0.3),
                          child: ElevatedButton(
                            child: Text('Взрослый', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: height * 0.1, left: width * 0.2),
                          child: Text('Список профилей:', style: GoogleFonts.jost(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.1, right: width * 0.3),
                          child: ElevatedButton(
                            child: Text('Поиск', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF86B0CB),
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01, left: width * 0.2),
                      color: Color(0xFFDBE7EF),
                      height: height * 0.25,
                      width: width * 0.5,
                      child: isLoaded ? ListView.builder(
                        itemCount: people.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              child: Text(people[index]['name']! + ' ' + people[index]['surname']!, style: GoogleFonts.jost(color: selectedProfile == index ? Colors.white : Colors.black, fontSize: 16),),
                              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, bottom: height * 0.01),
                              padding: EdgeInsets.only(left: width * 0.02, bottom: 14, top: 14),
                              decoration: BoxDecoration(
                                  color: selectedProfile == index ? Color(0xFF367CA9) : Colors.white,
                                  borderRadius: BorderRadius.circular(6)
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedProfile == index) {
                                  selectedProfile = -1;
                                } else {
                                  selectedProfile = index;
                                }
                              });
                            },
                          );
                        },
                      ) : Center(
                        child: CircularProgressIndicator(color: Colors.white,),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02, left: width * 0.2),
                          child: ElevatedButton(
                            child: Text('Назад', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF86B0CB),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02, right: width * 0.3),
                          child: ElevatedButton(
                            child: Text('Выбрать', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF86B0CB),
                            ),
                            onPressed: () {
                              selectProfile();
                            },
                          ),
                        ),
                      ],
                    ),
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