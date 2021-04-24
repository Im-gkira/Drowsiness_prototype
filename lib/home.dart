import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dds/detector/live_camera.dart';
import 'package:dds/map/map.dart';
import 'package:dds/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          left: 15.0,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/images/Sunset.png'),
          ),
        ),
        //color: Color(0xFFeeebe2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Quote(),
            Button(
              Icons.camera_alt_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveFeed(cameras),
                  ),
                );
              },
              'Camera',
            ),
            Button(
              Icons.map_outlined,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GMap(cameras),
                  ),
                );
              },
              'Map',
            ),
            Button(
              Icons.settings_outlined,
              () {},
              'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 30.0, right: 20.0, left: 20.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(width: 3.0, color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  'It is better to travel well than to arrive.',
                  style: GoogleFonts.oldenburg(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.format_quote,
                color: Colors.white,
                size: 24.0,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '- Arthur C. Custance',
            style: GoogleFonts.oldenburg(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final String name;
  Button(this.icon, this.onPressed, this.name);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: Icon(
            icon,
            size: 30.0,
            color: Colors.blue,
          ),
          onPressed: onPressed,
        ),
        Text(
          name,
          style: GoogleFonts.oldenburg(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        SizedBox(
          height: 25.0,
          child: Divider(
            indent: MediaQuery.of(context).size.width * 0.4,
            endIndent: MediaQuery.of(context).size.width * 0.4,
            thickness: 2.0,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}

class Title extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80.0,
      ),
      child: Transform.rotate(
        angle: -math.pi / 2,
        child: Text(
          'SUN',
          style: GoogleFonts.permanentMarker(
            textStyle: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
