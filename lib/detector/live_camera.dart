import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dds/detector/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:provider/provider.dart';
import 'package:dds/response.dart';
// import 'package:dds/detector/bounding_box.dart';
// import 'dart:math' as math;

class LiveFeed extends StatefulWidget {
  final List<CameraDescription> cameras;

  LiveFeed(this.cameras);

  @override
  _LiveFeedState createState() => _LiveFeedState();
}

class _LiveFeedState extends State<LiveFeed> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

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
    loadTfModel();
  }

  @override
  Widget build(BuildContext context) {
    // Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CameraFeed(widget.cameras, setRecognitions, 1.0),
          // BoundingBox(
          //   _recognitions == null ? [23,23] : _recognitions,
          //   math.max(_imageHeight, _imageWidth),
          //   math.min(_imageHeight, _imageWidth),
          //   screen.height,
          //   screen.width,
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Provider.of<CameraData>(context, listen: true).icon),
        backgroundColor: Provider.of<CameraData>(context, listen: true).colour,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
