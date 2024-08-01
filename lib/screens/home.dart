import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
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
              )
            ],
          )
        ],
      ),
    );
  }
}