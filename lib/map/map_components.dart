import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationTile extends StatelessWidget {
  final String _instructions;
  final String _action;
  final String _distance;
  final String _totalDistance;
  final Function onPressed;
  NavigationTile(this.onPressed, this._totalDistance, this._instructions,
      this._action, this._distance);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      // decoration: BoxDecoration(
      //   color: Colors.lightBlueAccent,
      //   borderRadius: BorderRadius.circular(30.0),
      //   border: Border.all(
      //     width: 5.0,
      //     color: Colors.blue,
      //   ),
      // ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomRight,
      // curve: Curves.easeIn,
      // duration: Duration(milliseconds: 100),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            //height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                width: 5.0,
                color: Colors.blue,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(15.0),
                      //   color: Colors.black,
                      //   border: Border.all(
                      //     width: 5.0,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                      padding: EdgeInsets.only(bottom: 10.0),
                      //margin: EdgeInsets.all(2.5),
                      width: MediaQuery.of(context).size.width * 0.36,
                      height: 40.0,
                      child: Center(
                        child: Text(
                          '$_action',
                          style: GoogleFonts.concertOne(
                            textStyle: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //alignment: Alignment.topCenter,
                      //width: MediaQuery.of(context).size.width * 0.2,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(15.0),
                      //   color: Colors.black,
                      //   border: Border.all(
                      //     width: 5.0,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                      padding: EdgeInsets.only(bottom: 10.0),
                      //margin: EdgeInsets.all(2.5),
                      width: MediaQuery.of(context).size.width * 0.36,
                      height: 40.0,
                      child: Center(
                        child: Text(
                          '$_distance',
                          style: GoogleFonts.concertOne(
                            textStyle: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(15.0),
                  //   color: Colors.black,
                  //   border: Border.all(
                  //     width: 5.0,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  padding: EdgeInsets.only(bottom: 10.0),
                  height: 40.0,
                  child: Center(
                    child: Text(
                      '$_instructions',
                      style: GoogleFonts.concertOne(
                        textStyle: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.black,
                    border: Border.all(
                      width: 5.0,
                      color: Colors.blue,
                    ),
                  ),
                  height: 50.0,
                  padding: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Center(
                    child: Text(
                      '$_totalDistance',
                      style: GoogleFonts.concertOne(
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  //padding: EdgeInsets.only(right: 5.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      //foregroundColor: MaterialStateProperty.all<Color>(colour),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.black,
                      ),
                      shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder(),
                      ),
                      fixedSize: MaterialStateProperty.all(
                        Size(50.0, 50.0),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Colors.red,
                          width: 5.0,
                        ),
                      ),
                    ),
                    onPressed: onPressed,
                    child: Icon(
                      Icons.close,
                      size: 35.0,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmallButton extends StatelessWidget {
  SmallButton(this.onPressed, this.icon, this.colour, this.size);
  final Function onPressed;
  final Icon icon;
  final Color colour;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(
          //foregroundColor: MaterialStateProperty.all<Color>(colour),
          //splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.all<Color>(colour),
          shadowColor: MaterialStateProperty.all<Color>(colour),
          shape: MaterialStateProperty.all<CircleBorder>(
            CircleBorder(),
          ),
          fixedSize: MaterialStateProperty.all(
            Size(size, size),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: Colors.blue,
              width: 3.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}

class NewButton extends StatelessWidget {
  NewButton(this.onPressed, this.icon, this.colour, this.size);
  final Function onPressed;
  final Icon icon;
  final Color colour;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ButtonStyle(
          //foregroundColor: MaterialStateProperty.all<Color>(colour),
          splashFactory: NoSplash.splashFactory,
          backgroundColor: MaterialStateProperty.all<Color>(colour),
          shadowColor: MaterialStateProperty.all<Color>(colour),
          shape: MaterialStateProperty.all<CircleBorder>(
            CircleBorder(),
          ),
          fixedSize: MaterialStateProperty.all(
            Size(size, size),
          ),
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: Colors.blue,
              width: 3.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
