import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dds/home.dart';
import 'package:provider/provider.dart';
import 'package:dds/response.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(
    ChangeNotifierProvider<CameraData>(
      create: (context) {
        return CameraData();
      },
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
