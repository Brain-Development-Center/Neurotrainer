import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void signIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      final db = FirebaseFirestore.instance;
      String organization = '';
      await db.collection('users').doc(credential.user!.uid).get().then((snapshot) {
        organization = snapshot.data()!['organization'];
      });
      int? activations;
      bool isActivate = false;
      await db.collection('organizations').doc(organization).get().then((snapshot) {
        activations = snapshot.data()!['activations'];
      });
      await db.collection('organizations').doc(organization).collection('users').doc(credential.user!.uid).get().then((snapshot) {
        isActivate = snapshot.data()!['activate'];
      });
      if (activations == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Уже активировано максимальное количество устройств в этой организации')));
      } else if (isActivate) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Данный аккаунт уже активирован')));
      } else {
        await db.collection('organizations').doc(organization).set({'activations': activations! - 1});
        await db.collection('organizations').doc(organization).collection('users').doc(credential.user!.uid).set({'activate': true});
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(user: credential.user)));
      }
    } catch (e) {
      print(e);
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
          Image.asset("assets/logo.png", height: height * 0.4,),
          Container(
            margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Логин',
                prefixIcon: Icon(Icons.email),
                filled: true,
                fillColor: Color(0xFFedf0f8),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2, top: height * 0.02),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Пароль',
                  prefixIcon: Icon(Icons.email),
                  filled: true,
                  fillColor: Color(0xFFedf0f8),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)
                  )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
            child: ElevatedButton(
              onPressed: () {
                signIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              child: Text('Войти', style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}