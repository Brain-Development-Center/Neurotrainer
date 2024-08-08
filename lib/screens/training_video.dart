import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';


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

  // void _getText() async {
  //   String t;
  //   try {
  //     final result = await platform.invokeMethod<String>('connectBluetooth');
  //     t = result.toString();
  //   } on PlatformException catch (e) {
  //     t = 'Failed';
  //   }
  //   setState(() {
  //     text = t;
  //     print(text);
  //   });
  // }

  List<String> devices = [];

  void _getDevices() async {
    while (true) {
      List<String> ds = [];
      try {
        final result = await platform.invokeMethod<Map<Object?, Object?>>("call");
        result!.forEach((Object? key, Object? value) {
          ds.add(value.toString());
        });
      } on PlatformException catch (e) {
        print(e);
      }
      setState(() {
        devices = ds;
      });
    }
  }

  void startScan() async {
    try {
      platform.invokeMethod<String>("scan");
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Timer? timer;

  int successSeconds = 0;
  int bestSuccessSeconds = 0;

  // void getNums() async {
  //   while (true) {
  //     List<double> t;
  //     try {
  //       final result = await platform.invokeMethod<List<double>>('getNum');
  //       t = result!;
  //     } on PlatformException catch (e) {
  //       t = [];
  //     }
  //     print(t);
  //     if (attention != t[8]) {
  //       setState(() {
  //         attention = t[8];
  //         if (trainingMode == 1 && attention < 70) {
  //           videoPlayerController.pause();
  //           setState(() {
  //             timer = Timer.periodic(Duration(seconds: 1), (Timer _timer) {
  //               setState(() {
  //                 successSeconds++;
  //               });
  //             });
  //           });
  //           isSuccess = false;
  //         } else if (!isSuccess) {
  //           videoPlayerController.play();
  //           setState(() {
  //             timer!.cancel();
  //           });
  //         }
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _getText();
    // getNums();
    startScan();
    _getDevices();
  }

  double attention = 0;

  bool isTraining = false;
  bool isSuccess = false;

  bool isConnected = false;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  bool windowOpened = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: SvgPicture.asset('assets/select_mode_4.svg', width: width * 0.2,),
            margin: EdgeInsets.only(bottom: height * 0.01, left: width * 0.01),
          ),
          Container(
            height: height,
            width: width,
            child: Column(
              children: [
                SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.white, size: width * 0.03,),
                                  onPressed: () {},
                                  style: IconButton.styleFrom(
                                      backgroundColor: Color(0xFFC18686)
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                child: Text('Завершить', style: GoogleFonts.jost(color: Colors.white, fontSize: width * 0.03),),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF86B0CB)
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text('Время сессии', style: GoogleFonts.jost(color: Colors.black, fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                              ),
                              Container(
                                child: Text('9:58', style: GoogleFonts.jost(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                                padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                                decoration: BoxDecoration(
                                    color: Color(0xFF86B0CB),
                                    borderRadius: BorderRadius.circular(26)
                                ),
                                margin: EdgeInsets.only(left: width * 0.01),
                              ),
                              Container(
                                child: Text(isConnected ? 'ON' : 'OFF', style: GoogleFonts.jost(color: isConnected ? Color(0xFF86BCC1) : Color(0xFFC18686), fontWeight: FontWeight.bold, fontSize: width * 0.03),),
                                margin: EdgeInsets.only(right: width * 0.01, left: width * 0.02),
                              ),
                              Container(
                                height: width * 0.06,
                                width: width * 0.06,
                                margin: EdgeInsets.only(right: width * 0.01),
                                child: IconButton(
                                  icon: SvgPicture.asset('assets/infinity.svg', fit: BoxFit.cover, width: width * 0.04,),
                                  onPressed: () {
                                    setState(() {
                                      windowOpened = !windowOpened;
                                    });
                                  },
                                  style: IconButton.styleFrom(
                                      backgroundColor: isConnected ? Color(0xFF86BCC1) : Color(0xFFC18686)
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.only(top: height * 0.02),
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: width,
                            margin: EdgeInsets.only(bottom: height * 0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: width * 0.05),
                                  padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.fast_rewind_rounded, color: Color(0xFFABABAB)),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.push_pin, color: Colors.white),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.replay_5, color: Color(0xFFABABAB)),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.play_arrow, color: Color(0xFFABABAB)),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.forward_5, color: Color(0xFFABABAB)),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.close, color: Colors.white),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: width * 0.01),
                                        height: width * 0.04,
                                        width: width * 0.04,
                                        child: IconButton(
                                            icon: Icon(Icons.fast_forward, color: Color(0xFFABABAB)),
                                            padding: EdgeInsets.all(0),
                                            style: IconButton.styleFrom(
                                              iconSize: width * 0.025,
                                              backgroundColor: Color(0xFFD9D9D9),
                                            ),
                                            onPressed: () {}
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.01),
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(26)
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                      GestureDetector(
                                        child: Icon(Icons.fullscreen, color: Colors.white, size: width * 0.05,),
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
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: width * 0.05, top: height * 0.01),
                      child: Text(training, style: GoogleFonts.jost(color: Color(0xFF86B0CB), fontSize: width * 0.04, fontWeight: FontWeight.bold),),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.5,
                      padding: EdgeInsets.only(bottom: height * 0.1),
                      margin: EdgeInsets.only(left: width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.01),
                            child: Text('Режим видео:', style: GoogleFonts.jost(color: Color(0xFF86B0CB), fontSize: width * 0.03),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.01),
                            child: Text('Режим видео', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.005),
                            child: Text('Режим видео', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.005),
                            child: Text('Режим видео', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.005),
                            child: Text('Режим видео', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02),),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02, top: height * 0.005),
                            child: Text('Режим видео', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02),),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xFFDBE7EF),
                          borderRadius: BorderRadius.circular(26)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.05),
                      width: width * 0.1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Container(
                            height: height * 0.01,
                            margin: EdgeInsets.only(top: height * 0.005),
                            decoration: BoxDecoration(
                                color: Color(0xFF86B0CB),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(right: width * 0.01, bottom: height * 0.05),
                    child: ElevatedButton(
                      child: Container(
                        width: width * 0.1,
                        child: Icon(Icons.play_arrow, color: Color(0xFF5E96BA), size: width * 0.05,),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 6, bottom: 6, left: width * 0.05, right: width * 0.05),
                        backgroundColor: Color(0xFF5E96BA),
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
          ),
          windowOpened ? Container(
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.5,
                    width: width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7
                        )]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text('Bluetooth', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.03, fontWeight: FontWeight.bold),),
                              margin: EdgeInsets.only(left: width * 0.03, top: height * 0.01),
                            ),
                           Container(
                             child:  IconButton(
                               icon: Icon(Icons.close, color: Colors.white,),
                               onPressed: () {
                                 setState(() {
                                   windowOpened = false;
                                 });
                               },
                               style: IconButton.styleFrom(
                                   backgroundColor: Color(0xFF86B0CB)
                               ),
                             ),
                             margin: EdgeInsets.only(right: width * 0.03, top: height * 0.01),
                           )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        Container(
                          width: width * 0.6,
                          margin: EdgeInsets.only(left: width * 0.05),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(top: height * 0.02),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(devices[index], style: GoogleFonts.jost(color: Colors.white, fontSize: width * 0.02),),
                                    ElevatedButton(
                                      child: Text('Подключиться', style: GoogleFonts.jost(color: Colors.black, fontSize: width * 0.02)),
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF86B0CB),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, top: 4, bottom: 4),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
          ) : Container(),
        ],
      )
    );
  }
}