import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraData extends ChangeNotifier {
  String cameraResponse = 'opened';
  IconData icon = Icons.check_circle;
  Color colour = Colors.green;

  void changeString(String newString) {
    cameraResponse = newString;
    icon = cameraResponse == 'opened' ? Icons.check_circle : Icons.close;
    colour = cameraResponse == 'opened' ? Colors.green : Colors.red;
    notifyListeners();
  }
}
