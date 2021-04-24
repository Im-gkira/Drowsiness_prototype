import 'package:dds/map/map_components.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

String searched = '';

class SearchScreen extends StatefulWidget {
  final Position _currentLocation;
  SearchScreen(this._currentLocation);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LatLng destination;
  List<Widget> searchEntries = [];

  Future searchPlaces(String val) async {
    var queryURL = Uri.parse(
        'https://autosuggest.search.hereapi.com/v1/autosuggest?at=${widget._currentLocation.latitude},${widget._currentLocation.longitude}&limit=5&lang=en&q=$val&apiKey=NiiTFXd01NCOWmQqzJm2KS1w5wFyMD5ShPZ0d1vpmCY');

    http.Response response = await http.get(queryURL);
    //print(response.body);
    var searchData = jsonDecode(response.body);

    searchEntries.clear();
    for (var entries in searchData['items']) {
      if (entries['address'] != null) {
        searchEntries.add(
          SearchWidget(
            entries,
            () {
              destination = LatLng(
                entries['position']['lat'],
                entries['position']['lng'],
              );
              Navigator.pop(context, destination);
            },
          ),
        );
        //print(entries['categories']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        //color: Colors.black,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/images/search.jpeg'),
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SmallButton(
                () {
                  Navigator.pop(context);
                },
                Icon(
                  Icons.navigate_before,
                  color: Colors.blue,
                ),
                Colors.black,
                50.0,
              ),
            ),
            Current(),
            SearchBox(
              () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                searched == '' ? print('null') : await searchPlaces(searched);
                setState(() {});
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: searchEntries,
            ),
          ],
        ),
      ),
    );
  }
}

class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 5.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: 30.0,
            width: 30.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50.0,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 15.0, left: 10.0, right: 10.0),
            margin: EdgeInsets.only(left: 10.0, right: 5.0),
            child: Text(
              'Current Location',
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final Function onPressed;
  SearchBox(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 5.0),
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: 30.0,
            width: 30.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 2.0,
                color: Colors.white,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50.0,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 15.0, left: 10.0, right: 10.0),
            margin: EdgeInsets.only(left: 5.0, right: 5.0),
            child: TextField(
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              autofocus: false,
              cursorHeight: 25.0,
              cursorColor: Colors.blue,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (value) {
                searched = value;
              },
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.black.withOpacity(0.75),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              fixedSize: MaterialStateProperty.all(
                Size(50, 50),
              ),
              elevation: MaterialStateProperty.all<double>(0.0),
            ),
            onPressed: onPressed,
            child: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  final data;
  final Function onTap;
  SearchWidget(this.data, this.onTap);

  String getDistance() {
    if (data['distance'] >= 1000) {
      return (data['distance'] / 1000).toStringAsFixed(2) + ' km';
    } else {
      return (data['distance']).toString() + ' m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 2.5,
            color: Colors.white,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(data['title'], 25, Colors.white),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: StyledText(data['address']['label'], 20, Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.directions_outlined,
                    color: Colors.blue,
                    size: 20.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                StyledText(getDistance(), 20, Colors.white),
              ],
            ),
            //StyledText(data['categories'][0]['name']),
          ],
        ),
      ),
    );
  }
}

class StyledText extends StatelessWidget {
  final String text;
  final double height;
  final Color colour;
  StyledText(this.text, this.height, this.colour);
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: GoogleFonts.ubuntu(
        textStyle: TextStyle(
          height: 1,
          fontSize: height,
          color: colour,
        ),
      ),
    );
  }
}
