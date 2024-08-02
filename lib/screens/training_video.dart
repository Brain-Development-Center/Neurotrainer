import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';


class TrainingVideoScreen extends StatefulWidget {

  @override
  _TrainingVideoScreenState createState() => _TrainingVideoScreenState();
}


class _TrainingVideoScreenState extends State<TrainingVideoScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Container(
                height: height * 0.3,
                width: width,
                color: Color(0xFFD9D9D9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.perm_media_outlined, size: 60, color: Colors.black,),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(20)
                      ),
                      onPressed: () {},
                    )
                  ],
                )
            ),
          )
        ],
      ),
    );
  }
}