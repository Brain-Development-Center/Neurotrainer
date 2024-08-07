import 'package:flutter/cupertino.dart';
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

  TextEditingController searchController = TextEditingController();

  String? franchisee;

  int type = 0;

  List<String> adults = [];
  List<String> children = [];
  Map<String, Map<String, String>> names = {};

  List<String> search = [];

  bool isLoaded = false;

  void getUsers() async {
    final storage = new FlutterSecureStorage(aOptions: _getAndroidOptions());
    franchisee = await storage.read(key: "franchisee", aOptions: _getAndroidOptions());
    final snapshot = await FirebaseFirestore.instance.collection('organizations').doc(franchisee).collection('users').get();
    snapshot.docs.forEach((snapshot) {
      String person = snapshot.data()['name'] + ' ' + snapshot.data()['surname'];
      Map<String, String> info = {
        'name': snapshot.data()['name'],
        'surname': snapshot.data()['surname']
      };
      if (snapshot.data()['type'] == 'adult') {
        adults.add(person);
      } else {
        children.add(person);
      }
      names[person] = info;
      search = children;
    });
    setState(() {
      isLoaded = true;
    });
  }

  int selectedProfile = -1;

  void selectProfile() async {
    if (selectedProfile == -1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Вы не выбрали профиль')));
    } else {
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      await storage.write(key: 'name', value: type == 0 ? names[children[selectedProfile]]!['name'] : names[adults[selectedProfile]]!['name'], aOptions: _getAndroidOptions());
      await storage.write(key: 'surname', value: type == 0 ? names[children[selectedProfile]]!['surname'] : names[adults[selectedProfile]]!['surname'], aOptions: _getAndroidOptions());
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  bool isSearch = false;
  
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
                        margin: EdgeInsets.only(left: width * 0.04, top: height * 0.02),
                        child: SvgPicture.asset('assets/select_mode_4.svg', width: width * 0.2,),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: height * 0.1, left: width * 0.1),
                      child: Text('Выбор профиля:', style: GoogleFonts.jost(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02),
                          child: ElevatedButton(
                            child: Text('Ребенок', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: type == 0 ? Color(0xFF367CA9) : Color(0xFF86B0CB),
                            ),
                            onPressed: () {
                              setState(() {
                                search = children;
                                type = 0;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.02, left: width * 0.05),
                          child: ElevatedButton(
                            child: Text('Взрослый', style: GoogleFonts.jost(color: Colors.white, fontSize: 16),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: type == 1 ? Color(0xFF367CA9) : Color(0xFF86B0CB),
                            ),
                            onPressed: () {
                              setState(() {
                                search = adults;
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
                        isSearch ? Container() : Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: height * 0.1, left: width * 0.1),
                          child: Text('Список профилей:', style: GoogleFonts.jost(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.1, right: width * 0.2),
                          width: isSearch ? width * 0.7 : width * 0.2,
                          child: TextField(
                            keyboardType: TextInputType.name,
                            controller: searchController,
                            cursorColor: Colors.white,
                            style: GoogleFonts.jost(color: Colors.white),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: width * 0.03, top: 12, bottom: 12),
                              hintText: 'Поиск',
                              prefixIcon: isSearch ? Icon(Icons.search, color: Colors.white,) : null,
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
                            onTap: () {
                              setState(() {
                                isSearch = true;
                              });
                            },
                            onSubmitted: (value) {
                              searchController.clear();
                              setState(() {
                                isSearch = false;
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                List<String> new_search = [];
                                if (type == 0) {
                                  children.forEach((person) {
                                    if (person.contains(value)) {
                                      new_search.add(person);
                                    }
                                  });
                                } else {
                                  adults.forEach((person) {
                                    if (person.contains(value)) {
                                      new_search.add(person);
                                    }
                                  });
                                }
                                search = new_search;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01, left: width * 0.1),
                      color: Color(0xFFDBE7EF),
                      height: height * 0.25,
                      width: width * 0.7,
                      padding: EdgeInsets.only(top: height * 0.01),
                      child: isLoaded ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: search.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            child: Container(
                              child: Text((type == 0 ? search[index] : search[index]), style: GoogleFonts.jost(color: selectedProfile == index ? Colors.white : Colors.black, fontSize: 16),),
                              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, bottom: height * 0.01),
                              padding: EdgeInsets.only(left: width * 0.02, bottom: 12, top: 12),
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
                            onDoubleTap: () {
                              setState(() {
                                selectedProfile = index;
                              });
                              selectProfile();
                            },
                          );
                        },
                      ) : Center(
                        child: CircularProgressIndicator(color: Colors.white,),
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                          margin: EdgeInsets.only(top: height * 0.02, left: width * 0.05),
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