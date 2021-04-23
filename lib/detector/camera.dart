import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:dds/response.dart';
import 'package:provider/provider.dart';

typedef void Callback(List<dynamic> list, int h, int w);
var result;

class CameraFeed extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final double aspectRatio;

  // The cameraFeed Class takes the cameras list and the setRecognitions
  // function as argument
  CameraFeed(this.cameras, this.setRecognitions, this.aspectRatio);

  @override
  _CameraFeedState createState() => new _CameraFeedState();
}

class _CameraFeedState extends State<CameraFeed> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    print(widget.cameras);
    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No Cameras Found.');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.ultraHigh,
        enableAudio: false,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;
            Tflite.runModelOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    // model: "SSDMobileNet",
                    imageHeight: img.height,
                    imageWidth: img.width,
                    imageMean: 127.5,
                    imageStd: 127.5,
                    rotation: 90,
                    numResults: 2,
                    threshold: 0.4,
                    asynch: true)
                .then((recognitions) {
              /*
              When setRecognitions is called here, the parameters are being passed on to the parent widget as callback. i.e. to the LiveFeed class
               */
              recognitions.forEach((response) {
                print(response["label"]);
                result = response["label"];
                Provider.of<CameraData>(context, listen: false)
                    .changeString(result);
              });
              widget.setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = (math.max(tmp.height, tmp.width)) / widget.aspectRatio;
    var screenW = (math.min(tmp.height, tmp.width)) / widget.aspectRatio;
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 5.0,
          color: Colors.blue,
        ),
      ),
      margin: EdgeInsets.all(10.0),
      height:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      width:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: CameraPreview(controller),
      ),
    );
  }
}
