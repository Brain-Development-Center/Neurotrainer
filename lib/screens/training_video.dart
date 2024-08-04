import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';


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
    videoPlayerController = VideoPlayerController.file(file);
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
            child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Stack(
                children: [
                  Container(
                      width: width,
                      color: Color(0xFFD9D9D9),
                      child: type == -1 ?
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.perm_media_outlined, size: width * 0.05, color: Colors.black,),
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(width * 0.02)
                            ),
                            onPressed: () {
                              getVideo();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.05),
                              child: SvgPicture.asset('assets/youtube.svg', width: width * 0.09,),
                            ),
                            onTap: () {},
                          )
                        ],
                      ) : (type == 0 ? VideoPlayer(videoPlayerController!) : Container())
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: width,
                        margin: EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: width * 0.1),
                              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.replay_5, color: Color(0xFFABABAB),),
                                    style: IconButton.styleFrom(
                                        backgroundColor: Color(0xFFD9D9D9)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        videoPlayerController.seekTo(Duration(seconds: -5));
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.play_arrow, color: Color(0xFFABABAB),),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color(0xFFD9D9D9)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        videoPlayerController.play();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.forward_5, color: Color(0xFFABABAB),),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color(0xFFD9D9D9)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        videoPlayerController.seekTo(Duration(seconds: 5));
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Color(0xFFABABAB),),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Color(0xFFD9D9D9),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        type = -1;
                                        videoPlayerController.dispose();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: width * 0.02),
                              child: Row(
                                children: [
                                  Container(
                                    child: Center(
                                      child: Text('10:00/10:00', style: GoogleFonts.jost(color: Color(0xFFABABAB)),),
                                    ),
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.fullscreen, color: Colors.white, size: 38,),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
            )
          ),
        ],
      ),
    );
  }
}