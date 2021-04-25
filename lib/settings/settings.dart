import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/services.dart';

int limit = 2;

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final List<String> developers = ['Keshav', 'Gurkirat', 'Siddhant'];
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          SizedBox(
            height: 50.0,
          ),
          Center(
            child: Text(
              'DDS',
              style: TextStyle(
                  color: Colors.white, fontSize: 60.0, fontFamily: 'Cubano'),
            ),
          ),
          Center(
            child: Text(
              'Version 1.0.1',
              style: TextStyle(
                  color: Colors.white, fontSize: 20.0, fontFamily: 'Cubano'),
            ),
          ),
          SizedBox(
            height: 20.0,
            child: Divider(
              indent: 30.0,
              endIndent: 30.0,
              thickness: 3.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          DivideBar(
            title: 'The Team',
            colour: Colors.pink,
          ),
          SizedBox(
            height: 10.0,
          ),
          CarouselSlider(
              options: CarouselOptions(
                enlargeCenterPage: true,
              ),
              carouselController: _controller,
              items: developers
                  .map((item) => ImageAvatar(
                        name: item,
                      ))
                  .toList()),
          SizedBox(
            height: 50.0,
          ),
          DivideBar(
            title: 'Contact Us',
            colour: Colors.purple,
          ),
          SizedBox(
            height: 10.0,
          ),
          ContactUs(),
          SizedBox(
            height: 50.0,
          ),
          InstructionsWidget(
            question: 'Made With Love. Hope You Enjoy :)',
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

class ImageAvatar extends StatelessWidget {
  ImageAvatar({this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    Path customPath1 = Path();
    customPath1.addOval(Rect.fromCircle(
      center: Offset(47, 47),
      radius: 51.0,
    ));

    Path customPath2 = Path();
    customPath2.addOval(Rect.fromCircle(
      center: Offset(49, 49),
      radius: 61.0,
    ));

    Path customPath3 = Path();
    customPath3.addOval(Rect.fromCircle(
      center: Offset(51, 51),
      radius: 70.0,
    ));

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 40.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(width: 3.0, color: Colors.white),
      ),
      child: ListView(
        children: [
          Center(
            child: DottedBorder(
              customPath: (_) => customPath3,
              color: Colors.pink,
              dashPattern: [25, 10],
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              child: DottedBorder(
                customPath: (_) => customPath2,
                color: Colors.purple,
                dashPattern: [15, 9],
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                child: DottedBorder(
                  customPath: (_) => customPath1,
                  color: Colors.indigo,
                  dashPattern: [10, 9],
                  strokeWidth: 6,
                  strokeCap: StrokeCap.round,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/$name.jpg'),
                    radius: 45.0,
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              name,
              style: GoogleFonts.permanentMarker(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DivideBar extends StatelessWidget {
  DivideBar({this.title, this.colour});
  final String title;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
          margin: EdgeInsets.symmetric(horizontal: 30.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 3.0,
              color: colour,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.concertOne(
                textStyle: TextStyle(
                  fontSize: 40.0,
                  color: colour,
                ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   child: Divider(
        //     color: colour,
        //     thickness: 3.0,
        //     indent: 30.0,
        //     endIndent: 30.0,
        //   ),
        // ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}

class InstructionsWidget extends StatefulWidget {
  InstructionsWidget({this.question});
  final String question;
  @override
  _InstructionsWidgetState createState() => _InstructionsWidgetState();
}

class _InstructionsWidgetState extends State<InstructionsWidget> {
  List<Widget> displayList = [];
  double _height = 50;

  @override
  void initState() {
    super.initState();
    displayList = [];
    displayList.add(
      Text(
        widget.question,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: _height,
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            decoration: BoxDecoration(),
            duration: Duration(milliseconds: 500),
            child: ListView(
              children: displayList,
            ),
          ),
          onTap: () {
            setState(() {
              if (_height == 50) {
                _height = 130;
                displayList.add(
                  TextField(
                    onChanged: (value) {
                      if (value != null && value != '') {
                        limit = int.parse(value);
                      }
                    },
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              } else {
                _height = 50;
                displayList = [];
                displayList.add(
                  Text(
                    widget.question,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }
            });
          },
        ),
      ],
    );
  }
}

class ContactUs extends StatelessWidget {
  void sendMail() async {
    const uri =
        'mailto:thecodepolice@gmail.com?subject=Greetings&body=Hello%20World';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      //Fluttertoast.showToast(msg: 'Could not launch $uri');
    }
  }

  void sendGitHub() async {
    const uri = 'https://github.com/Im-gkira/Drowsiness_prototype';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      //Fluttertoast.showToast(msg: 'Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: Colors.white),
      ),
      child: Column(
        children: [
          Text(
            'If you are facing any issues then feel free to contact us any time.\n\nContact Info\n',
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 32,
                    ),
                    Text(
                      'Mail Us',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: sendMail,
              ),
              GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage(
                        'assets/images/github.png',
                      ),
                      height: 32.0,
                      width: 32.0,
                    ),
                    Text(
                      'Github',
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: sendGitHub,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
