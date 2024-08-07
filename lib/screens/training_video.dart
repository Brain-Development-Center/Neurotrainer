import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:flutter/services.dart';


class TrainingVideoScreen extends StatefulWidget {

  final String training;
  final int trainingMode;

  TrainingVideoScreen({Key? key, required this.training, required this.trainingMode}) : super(key: key);

  @override
  _TrainingVideoScreenState createState() => _TrainingVideoScreenState(training: training, trainingMode: trainingMode);
}


class _TrainingVideoScreenState extends State<TrainingVideoScreen> {

  final String training;
  final int trainingMode;

  _TrainingVideoScreenState({Key? key, required this.training, required this.trainingMode});

  static const platform = MethodChannel('com.bdc.neurotrainer/data');

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

  double attentionSum = 0;
  int count = 0;

  String text = 'None';

  void _getText() async {
    String t;
    try {
      final result = await platform.invokeMethod<String>('connectBluetooth');
      t = result.toString();
    } on PlatformException catch (e) {
      t = 'Failed';
    }
    setState(() {
      text = t;
      print(text);
    });
  }

  void getNums() async {
    while (true) {
      List<double> t;
      try {
        final result = await platform.invokeMethod<List<double>>('getNum');
        t = result!;
      } on PlatformException catch (e) {
        t = [];
      }
      print(t);
    }
  }

  @override
  void initState() {
    super.initState();
    _getText();
    getNums();
  }

  double attention = 0;

  bool isTraining = false;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                AspectRatio(
                  aspectRatio: 16.0 / 9.0,
                  child: Container(
                      width: width,
                      color: Color(0xFFD9D9D9),
                      child: type == -1 ?
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.perm_media_outlined, size: width * 0.08, color: Colors.black,),
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(width * 0.04)
                            ),
                            onPressed: () {
                              getVideo();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.05),
                              child: SvgPicture.asset('assets/youtube.svg', width: width * 0.16,),
                            ),
                            onTap: () {},
                          )
                        ],
                      ) : (type == 0 ? VideoPlayer(videoPlayerController) : Container())
                  ),
                ),
                (type == 0 || type == 1) ? Column(
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
                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                ) : Container()
              ],
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: width * 0.05, top: height * 0.01),
                child: Text(training, style: GoogleFonts.jost(color: Color(0xFF86B0CB), fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
                      margin: EdgeInsets.only(right: width * 0.01, top: height * 0.01),
                      decoration: BoxDecoration(
                          color: Color(0xFF86BCC1),
                          borderRadius: BorderRadius.circular(26)
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/training_video_successful.svg', height: height * 0.015,),
                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Успешность', style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26)
                            ),
                            child: Text('10:00', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
                      margin: EdgeInsets.only(right: width * 0.01, top: height * 0.01),
                      decoration: BoxDecoration(
                          color: Color(0xFF86B0CB),
                          borderRadius: BorderRadius.circular(26)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            child: Text('Успешность', style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26)
                            ),
                            child: Text('10:00', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      height: height * 0.3,
                      width: 8,
                      decoration: BoxDecoration(
                          color: Color(0xFF86B0CB)
                      )
                  ),
                  Container(
                    height: 10,
                    width: 50,
                    margin: EdgeInsets.only(bottom: height * 0.003 * attention),
                    decoration: BoxDecoration(
                        color: Color(0xFF3F3F3F),
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                ],
              ),
              trainingMode == 1 ?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: width * 0.15,
                          height: width * 0.1,
                          color: Color(0xFFC18686),
                          child: Center(
                            child: Text('Сложно', style: GoogleFonts.jost(color: Colors.white),),
                          ),
                        ),
                        Container(
                          width: width * 0.15,
                          height: width * 0.1,
                          margin: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01),
                          color: Color(0xFF86BCC1),
                          child: Center(
                            child: Text('Средне', style: GoogleFonts.jost(color: Colors.white),),
                          ),
                        ),
                        Container(
                          width: width * 0.15,
                          height: width * 0.1,
                          color: Color(0xFF86B0CB),
                          child: Center(
                            child: Text('Легко', style: GoogleFonts.jost(color: Colors.white),),
                          ),
                        )
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                          height: height * 0.2,
                          width: 8,
                          decoration: BoxDecoration(
                              color: Color(0xFF86B0CB)
                          )
                      ),
                      Container(
                        height: 10,
                        width: 50,
                        margin: EdgeInsets.only(bottom: height * 0.002 * attention),
                        decoration: BoxDecoration(
                            color: Color(0xFF3F3F3F),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ],
                  )
                ],
              ) : Container()
            ],
          ),
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(left: width * 0.01, bottom: height * 0.01),
              child: ElevatedButton(
                child: Text(isTraining ? 'Завершить' : 'Старт', style: GoogleFonts.jost(color: Colors.white, fontSize: 18),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF86B0CB),
                ),
                onPressed: () {
                  setState(() {
                    isTraining = true;
                    videoPlayerController.play();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}