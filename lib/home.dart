import 'package:flutter/material.dart';
import 'package:dds/detector/live_camera.dart';
import 'package:dds/map/map.dart';
import 'package:dds/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Real Time Detection"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveFeed(cameras),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Google Map"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GMap(cameras),
                      ),
                    );
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 160,
                child: ElevatedButton(
                  child: Text("Settings (TO BE IMPLEMENTED)"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
