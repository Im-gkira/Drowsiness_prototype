import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dds/detector/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:provider/provider.dart';
import 'package:dds/response.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:dds/settings/settings.dart';
// import 'package:dds/detector/bounding_box.dart';
// import 'dart:math' as math;

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Color colour;
  LiveFeed(this.cameras, this.colour);

  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  final oneSecond = Duration(seconds: 1);
  int counter = limit;
  Timer _timer;

  void startTimer() {
    final audioPlayer = AudioPlayer();
    AudioCache player = AudioCache(fixedPlayer: audioPlayer);
    //counter = 3;
    _timer = Timer.periodic(oneSecond, (timer) {
      if (counter < 0) {
        _timer.cancel();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            player.play('alert.wav');
            return Center(
              child: Container(
                height: 128.0,
                width: 128.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/alert.png'),
                  ),
                ),
              ),
            );
          },
        ).then((val) {
          print('Clearing Song');
          audioPlayer.stop();
          player.clearCache();
          audioPlayer.dispose();
        });
      }
      counter--;
    });
  }

  initCameras() async {}

  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/eyes_float.tflite",
      labels: "assets/labels.txt",
    );
  }

  /*
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    loadTfModel();
  }

  @override
  Widget build(BuildContext context) {
    // Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          GestureDetector(
            child: CameraFeed(
              widget.cameras,
              setRecognitions,
              1.0,
              widget.colour,
            ),
            onTap: () {
              if (_timer == null) {
                startTimer();
              } else {
                _timer.isActive ? _timer.cancel() : startTimer();
              }
            },
          ),
          // BoundingBox(
          //   _recognitions == null ? [23,23] : _recognitions,
          //   math.max(_imageHeight, _imageWidth),
          //   math.min(_imageHeight, _imageWidth),
          //   screen.height,
          //   screen.width,
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Provider.of<CameraData>(context, listen: true).icon),
      //   backgroundColor: Provider.of<CameraData>(context, listen: true).colour,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
    );
  }
}
