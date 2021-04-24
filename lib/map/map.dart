import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flexible_polyline/flexible_polyline.dart';
import 'package:flexible_polyline/latlngz.dart';
import 'package:dds/map/map_components.dart';
import 'package:dds/map/search.dart';
import 'package:camera/camera.dart';
import 'package:dds/detector/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dds/response.dart';

class GMap extends StatefulWidget {
  final List<CameraDescription> cameras;
  GMap(this.cameras);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Position _currentLocation;
  LatLng _destination;
  LatLng _center = LatLng(0, 0);
  GoogleMapController _controller;
  Set<Marker> markerList = {};
  List<LatLng> _points = [];
  String _instructions = '';
  String _distance = '';
  String _totalDistance = '';
  String _action = '';
  int i = 1;
  StreamSubscription<Position> _positionStream;
  List<Widget> navigationList = [];
  var ratio;
  String darkMapStyle;
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  initCameras() async {}

  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/eyes_float.tflite",
      labels: "assets/labels.txt",
    );
  }

  /*
  The set recognitions function assigns the values of recognitions, imageHeight and width to the variables defined here as callback
  */
  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void initState() {
    getLocation();
    loadTfModel();
    super.initState();
  }

  Future getMapStyle() async {
    darkMapStyle = await rootBundle.loadString('assets/dark.json');
    print(darkMapStyle);
    _controller.setMapStyle(darkMapStyle);
  }

  void getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    }
    _currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    Duration duration = Duration(milliseconds: 1);
    await Future.delayed(duration, () {});
    setState(() {
      _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);
      //placeMarkers(_center, '_center');
    });

    _controller.animateCamera(CameraUpdate.newLatLng(_center));
  }

  void placeMarkers(LatLng location, String id) {
    markerList.add(
      Marker(
        markerId: MarkerId(id),
        position: location,
      ),
    );
  }

  Future<Map<dynamic, dynamic>> getNavigationData() async {
    Map<dynamic, dynamic> data;
    var queryURL = Uri.parse(
        'https://router.hereapi.com/v8/routes?transportMode=car&origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${_destination.latitude},${_destination.longitude}&return=polyline,actions,instructions,summary&apiKey=NiiTFXd01NCOWmQqzJm2KS1w5wFyMD5ShPZ0d1vpmCY');

    http.Response response = await http.get(queryURL);
    data = jsonDecode(response.body);
    print(data['routes']);
    return data;
  }

  void buildRoute(Map<dynamic, dynamic> data) {
    if (data != null) {
      startandEndMarkers(data);
      _points.clear();
      List<LatLngZ> decoded = FlexiblePolyline.decode(
          "${data['routes'][0]['sections'][0]['polyline']}");
      for (var point in decoded) {
        _points.add(LatLng(point.lat, point.lng));
      }
      setState(() {});
    }
  }

  void startandEndMarkers(Map<dynamic, dynamic> data) {
    var arrival =
        data['routes'][0]['sections'][0]['arrival']['place']['location'];
    var departure =
        data['routes'][0]['sections'][0]['departure']['place']['location'];
    placeMarkers(LatLng(arrival['lat'], arrival['lng']), '_arrival');
    placeMarkers(LatLng(departure['lat'], departure['lng']), '_destination');
  }

  void getPositionStream(Map<dynamic, dynamic> data) async {
    var actions = data['routes'][0]['sections'][0]['actions'];
    var depart = data['routes'][0]['sections'][0]['departure']['place'];

    var calculatedLength = data['routes'][0]['sections'][0]['summary']
            ['length'] +
        Geolocator.distanceBetween(
            depart['location']['lat'],
            depart['location']['lng'],
            depart['originalLocation']['lat'],
            depart['originalLocation']['lng']);

    _positionStream = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation)
        .listen((Position position) {
      var point = i == actions.length
          ? _points[_points.length - 1]
          : _points[actions[i]['offset']];
      if (i > actions.length) {
        setState(() {
          cancelStream();
        });
      }

      _action = actions[i - 1]['action'];
      var distance = Geolocator.distanceBetween(position.latitude,
          position.longitude, point.latitude, point.longitude);
      if (distance >= 1000) {
        distance = distance / 1000;
        _distance = (distance).toStringAsFixed(2) + ' km';
      } else {
        _distance = (distance).toStringAsFixed(0) + ' m';
      }

      var totalDistance = calculatedLength -
          actions[i - 1]['length'] +
          (Geolocator.distanceBetween(position.latitude, position.longitude,
              point.latitude, point.longitude));
      if (totalDistance >= 1000) {
        totalDistance = totalDistance / 1000;
        _totalDistance = (totalDistance).toStringAsFixed(2) + ' km';
      } else {
        _totalDistance = (totalDistance).toStringAsFixed(0) + ' m';
      }
      _instructions = actions[i - 1]['instruction'].split(".")[0];

      if (Geolocator.distanceBetween(position.latitude, position.longitude,
              point.latitude, point.longitude) <
          10) {
        calculatedLength -= actions[i - 1]['length'];
        i++;
      }

      if (position.latitude.toStringAsFixed(5) !=
              _currentLocation.latitude.toStringAsFixed(5) ||
          position.longitude.toStringAsFixed(5) !=
              _currentLocation.longitude.toStringAsFixed(5)) {
        _currentLocation = position;
      }
      setState(() {
        // markerList.clear();
        _center = LatLng(_currentLocation.latitude, _currentLocation.longitude);
        // startandEndMarkers(data);
        //placeMarkers(_center, '_center');
        _controller.animateCamera(CameraUpdate.newLatLng(_center));
        navigationList.clear();
        navigationList.add(
          NavigationTile(
            () {
              markerList.clear();
              navigationList.clear();
              _destination = null;
              cancelStream();
              getLocation();
            },
            _totalDistance,
            _instructions,
            _action,
            _distance,
          ),
        );
      });
    });
  }

  void cancelStream() {
    _points.clear();
    if (_positionStream != null) {
      _positionStream.cancel();
      _positionStream = null;
    }
    _instructions = '';
    _distance = '';
    _action = '';
    _totalDistance = '';
  }

  @override
  void dispose() {
    cancelStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 17.0),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              getMapStyle();
            },
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: markerList,
            polylines: {
              Polyline(
                polylineId: PolylineId('routes'),
                points: _points,
                color: Colors.blue,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
              )
            },
            onLongPress: (position) {
              setState(() {
                _destination = position;
                placeMarkers(_destination, '_destination');
              });
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SmallButton(
                    () async {
                      if (_destination != null) {
                        markerList.clear();
                        cancelStream();
                        getLocation();
                        var data = await getNavigationData();
                        buildRoute(data);
                        getPositionStream(data);
                      }
                    },
                    Icon(
                      Icons.directions_outlined,
                      size: 35.0,
                      color: Colors.blue,
                    ),
                    Colors.black,
                    50.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SmallButton(() async {
                    markerList.clear();
                    getLocation();
                    _destination = null;
                    _destination = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SearchScreen(_currentLocation);
                        },
                      ),
                    );
                    if (_destination != null) {
                      placeMarkers(_destination, '_destination');
                      setState(() {});
                      _controller
                          .animateCamera(CameraUpdate.newLatLng(_destination));
                    }
                  },
                      Icon(
                        Icons.search_outlined,
                        color: Colors.blue,
                      ),
                      Colors.black,
                      50.0),
                  SizedBox(
                    height: 10.0,
                  ),
                  SmallButton(
                    () {
                      markerList.clear();
                      getLocation();
                    },
                    Icon(
                      Icons.navigation_outlined,
                      size: 35.0,
                      color: Colors.blue,
                    ),
                    Colors.black,
                    50.0,
                  ),
                ],
              ),
              Column(
                children: navigationList,
              )
            ],
          ),
          Container(
            child: CameraFeed(widget.cameras, setRecognitions, 3.0),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Provider.of<CameraData>(context, listen: true).icon),
      //   backgroundColor: Provider.of<CameraData>(context, listen: true).colour,
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
    );
  }
}
