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
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
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
            Column(
              children: searchEntries,
            ),
          ],
        ),
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
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 50.0,
            padding: EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            color: Colors.indigo,
            child: TextField(
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
              autofocus: false,
              cursorHeight: 40.0,
              cursorColor: Colors.pink,
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
                Colors.pink,
              ),
              shape: MaterialStateProperty.all<CircleBorder>(
                CircleBorder(),
              ),
              fixedSize: MaterialStateProperty.all(
                Size(50, 50),
              ),
              elevation: MaterialStateProperty.all<double>(0.0),
            ),
            onPressed: onPressed,
            child: Icon(
              Icons.search,
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
          color: Colors.indigo,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledText(data['title'], 25),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.pink,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: StyledText(data['address']['label'], 20),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.directions,
                  color: Colors.pink,
                ),
                SizedBox(
                  width: 10.0,
                ),
                StyledText(getDistance(), 20),
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
  StyledText(this.text, this.height);
  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: GoogleFonts.ubuntu(
        textStyle: TextStyle(
          height: 1,
          fontSize: height,
          color: Colors.white,
        ),
      ),
    );
  }
}
