import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  PermissionStatus permissionStatus;
  var location = new Location();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng pinPosition;
  GoogleMapController mapController;

  double frcity_Longitude, frcity_Latitude, tocity_Longitude, tocity_Latitude;
  var id;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Map<String, Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
    getTaskDetails();
  }

  Future getTaskDetails() async {
    location = new Location();

    Map<String, String> headers = {};
    SharedPreferences sharedPreferences;
    String access_token;

    final String taskDetailsUrl =
        'https://hotel.bicoders.com/api/MobDriverDetails/UpdatePicStatus';

    sharedPreferences = await SharedPreferences.getInstance();
    access_token = sharedPreferences.getString('access_token');
    id = sharedPreferences.getString('currentTaskId');

    print("access_token");
    print(access_token);

    headers['authorization'] = "bearer " + access_token;
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['No-Auth'] = "true";

    print("id is");
    print(id);

    dynamic taskDetailsBody = {
      'ID': id.toString(),
    };

    check().then((intenet) async {
      if (intenet != null && intenet) {
        var taskDetailsResponse = await http.post(
            Uri.encodeFull(taskDetailsUrl),
            headers: headers,
            body: taskDetailsBody);

        print("Tasks are");
        print(taskDetailsResponse.body);

        var taskDetailsResponseBody = json.decode(taskDetailsResponse.body);

        setState(() {
          frcity_Longitude = taskDetailsResponseBody["FRCITY_LONGITUDE"];
          frcity_Latitude = taskDetailsResponseBody["FRCITY_LATITUDE"];
          tocity_Longitude = taskDetailsResponseBody["TOCITY_LONGITUDE"];
          tocity_Latitude = taskDetailsResponseBody["TOCITY_LATITUDE"];
        });

        final toMarker = Marker(
          markerId: MarkerId("to_loc"),
          position: LatLng(
              double.parse(tocity_Latitude.toString().substring(0, 7)),
              double.parse(tocity_Longitude.toString().substring(0, 7))),
          infoWindow: InfoWindow(title: 'To Location'),
        );

        final fromMarker = Marker(
          markerId: MarkerId("from_loc"),
          position: LatLng(
              double.parse(frcity_Latitude.toString().substring(0, 7)),
              double.parse(frcity_Longitude.toString().substring(0, 7))),
          infoWindow: InfoWindow(title: 'To Location'),
        );

        setState(() {
          _markers["To Location"] = toMarker;
          _markers["From Location"] = fromMarker;
        });

        Timer.periodic(new Duration(seconds: 30), (timer) {
          _getLocation();
        });

        return "success";
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("Check Your Internet Connection and try again."),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return "success";
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Transporter'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(9, 76),
            zoom: 11,
          ),
          markers: _markers.values.toSet(),
        ),
        bottomSheet: Container(
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                ),
              ],
              color: Colors.white,
            ),
            height: 80.0,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ButtonTheme(
                        minWidth: deviceWidth * .2,
                        height: 40,
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0)),
                          child: new Text(
                            "View Details",
                            textScaleFactor: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: ButtonTheme(
                          minWidth: deviceWidth * .2,
                          height: 40,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.orange,
                            onPressed: () {
                              finishRide(id, tocity_Latitude, tocity_Longitude);
                            },
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0)),
                            child: new Text(
                              "Finish Ride",
                              textScaleFactor: 1.2,
                            ),
                          ),
                        ),
                      )),
                ])));
  }

  Future getPermission() async {
    permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permissionStatus.value == 2) {
      print("permisssion granted");
      _getLocation();
    } else {
      print("permisssion not granted");
      PermissionHandler()
          .requestPermissions([PermissionGroup.location]).then(onRequestAsked);
    }
  }

  onRequestAsked(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.location];
    setState(() {
      permissionStatus = status;
    });
  }

  _getLocation() async {
    try {
      LocationData currentLocation = await location.getLocation();
      pinPosition = LatLng(currentLocation.longitude, currentLocation.latitude);
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 10.0,
        ),
      ));

      setState(() {
        _markers["Current Location"] = marker;
      });
    } catch (e) {}
  }

//  void _getLocation() async {
//    print("reached here");
//    var currentLocation = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//    print(currentLocation);

//    setState(() {
//      _markers.clear();
//      final marker = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'Your Location'),
//      );
//      _markers["Current Location"] = marker;
//    });
//  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future finishRide(id, tocity_latitude, tocity_longitude) async {
    LatLng currentLoc = await _getLocation();
    print("latitude");
    var displacementString = distance(
        double.parse(tocity_latitude.toString().substring(0, 7)),
        double.parse(tocity_longitude.toString().substring(0, 7)),
        currentLoc.latitude,
        currentLoc.longitude);
    var displacement = double.parse(displacementString);

    if (displacement < 1) {
      finishTask(id);
    }
  }

  Future finishTask(id) async {
    Map<String, String> headers = {};
    SharedPreferences sharedPreferences;
    String access_token;

    final String finishTaskUrl =
        'https://hotel.bicoders.com/api/MobDriverDetails/UpdateDropStatus';

    sharedPreferences = await SharedPreferences.getInstance();
    access_token = sharedPreferences.getString('access_token');

    print("access_token");
    print(access_token);

    headers['authorization'] = "bearer " + access_token;
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['No-Auth'] = "true";

    print("id is");
    print(id);

    dynamic finishTaskBody = {
      'ID': id.toString(),
    };

    check().then((intenet) async {
      if (intenet != null && intenet) {
        var getAssignedDriverListResponse = await http.post(
            Uri.encodeFull(finishTaskUrl),
            headers: headers,
            body: finishTaskBody);

        print("Tasks are");
        print(getAssignedDriverListResponse.body);

        return "success";
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text("Check Your Internet Connection and try again."),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return "success";
    });
  }

  String distance(double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    dist = dist * 1.609344;
    return dist.toStringAsFixed(2);
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }
}
