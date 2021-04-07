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
    return AnimatedContainer(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          width: 5.0,
          color: Colors.indigoAccent,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.bottomRight,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 100),
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
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
              Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width * 0.2,
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
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
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
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
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
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    //foregroundColor: MaterialStateProperty.all<Color>(colour),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.pinkAccent,
                    ),
                    shadowColor: MaterialStateProperty.all<Color>(
                      Colors.red,
                    ),
                    shape: MaterialStateProperty.all<CircleBorder>(
                      CircleBorder(),
                    ),
                    fixedSize: MaterialStateProperty.all(
                      Size(50.0, 50.0),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Icon(
                    Icons.close,
                    size: 35.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
          backgroundColor: MaterialStateProperty.all<Color>(colour),
          shadowColor: MaterialStateProperty.all<Color>(colour),
          shape: MaterialStateProperty.all<CircleBorder>(
            CircleBorder(),
          ),
          fixedSize: MaterialStateProperty.all(
            Size(size, size),
          ),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
