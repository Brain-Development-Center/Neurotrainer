import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';


class TrainingVideoScreen extends StatefulWidget {

  @override
  _TrainingVideoScreenState createState() => _TrainingVideoScreenState();
}


class _TrainingVideoScreenState extends State<TrainingVideoScreen> {

  late VideoPlayerController videoPlayerController;

  int type = -1;

  void getVideo() async {
    final XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    File file = File(pickedFile!.path);
    videoPlayerController = VideoPlayerController.contentUri(file.uri);
    videoPlayerController.initialize();
    setState(() {
      type = 0;
    });
  }

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
                child: type == -1 ?
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.perm_media_outlined, size: 60, color: Colors.black,),
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(20)
                      ),
                      onPressed: () {
                        getVideo();
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: width * 0.05),
                        child: SvgPicture.asset('assets/youtube.svg', width: 100,),
                      ),
                      onTap: () {},
                    )
                  ],
                ) : (type == 0 ? VideoPlayer(videoPlayerController!) : Container())
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                videoPlayerController.play();
              });
            },
            icon: Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }
}