import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAcceptedSingleTask extends StatefulWidget {
  final id;
  final guestName;
  final picDate;
  final frCityId;
  final lFrom;
  final toCityId;
  final lTo;
  final trTp;
  final flight;
  final flightDetails;
  final qty;
  final adult;
  final child;
  final frcity_Longitude;
  final frcity_Latitude;
  final tocity_Longitude;
  final tocity_Latitude;

  DriverAcceptedSingleTask({
    this.id,
    this.guestName,
    this.picDate,
    this.frCityId,
    this.lFrom,
    this.toCityId,
    this.lTo,
    this.trTp,
    this.flight,
    this.flightDetails,
    this.qty,
    this.adult,
    this.child,
    this.frcity_Longitude,
    this.frcity_Latitude,
    this.tocity_Longitude,
    this.tocity_Latitude,
  });

  @override
  _DriverAcceptedSingleTaskState createState() =>
      _DriverAcceptedSingleTaskState();
}

class _DriverAcceptedSingleTaskState extends State<DriverAcceptedSingleTask> {
  bool detailsVisibility = false;
  PermissionStatus permissionStatus;
  var location = new Location();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  LatLng pinPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    var picDate = DateTime.parse(
      widget.picDate,
    );

    var format = new DateFormat.yMd().add_jm();

    String formatedPicDate = format.format(picDate);

    String tranType = getTrantype(widget.trTp);

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
          ),
        ],
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(5.0)),
      ),
      height: (detailsVisibility ? deviceHeight * .42 : deviceHeight * .23),
      margin: new EdgeInsets.all(10.0),
      padding: new EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.guestName,
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            formatedPicDate,
            textScaleFactor: 1,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Text(
                    widget.lFrom + "," + widget.frCityId,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  flex: 1,
                  child: Text(
                    "To",
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              Expanded(
                  flex: 4,
                  child: Text(
                    widget.lTo + "," + widget.toCityId,
                    textScaleFactor: 1.5,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
          SizedBox(height: 6),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Type :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    tranType,
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Visibility(
              visible: getFlightVisibility(detailsVisibility, widget.trTp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Flight Number :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.flight,
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Visibility(
              visible: getFlightVisibility(detailsVisibility, widget.trTp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Flight Details :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getString(widget.flightDetails),
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Visibility(
              visible: getFlightVisibility(detailsVisibility, widget.trTp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Number of Passengers :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getString(widget.qty),
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Visibility(
              visible: getFlightVisibility(detailsVisibility, widget.trTp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Number of Adults :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getString(widget.adult),
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Visibility(
              visible: getFlightVisibility(detailsVisibility, widget.trTp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Number Of Childern :",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getString(widget.child),
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          Visibility(
              visible: detailsVisibility ? true : false,
              child: SizedBox(height: 6)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: ButtonTheme(
                      minWidth: deviceWidth * .2,
                      height: 40,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          setState(() {
                            //ternary tried but failed, check again
                            if (detailsVisibility) {
                              detailsVisibility = false;
                            } else {
                              detailsVisibility = true;
                            }
                          });
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: new Text(
                          detailsVisibility ? "View Less" : "View More",
                          textScaleFactor: 1.2,
                        ),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: ButtonTheme(
                      minWidth: deviceWidth * .2,
                      height: 40,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.orange,
                        onPressed: () {
                          startRide(
                              widget.id,
                              picDate,
                              widget.frcity_Latitude,
                              widget.frcity_Longitude,
                              widget.tocity_Latitude,
                              widget.tocity_Longitude);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: new Text(
                          "Start Ride",
                          textScaleFactor: 1.2,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  String getTrantype(trTp) {
    switch (trTp) {
      case 0:
        return "Arrival";
      case 1:
        return "Departure";
      case 2:
        return "Internal";
    }
  }

  String getString(value) {
    return value == null ? "" : value.toString();
  }

  getFlightVisibility(bool detailsVisibility, trTp) {
    if (detailsVisibility) {
      if (trTp == 2) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future startRide(id, DateTime picDate, frcity_latitude, frcity_longitude,
      tocity_latitude, tocity_longitude) async {
    LatLng currentLoc = await _getLocation();
    print("latitude");
    var displacementString = distance(
        double.parse(frcity_latitude.toString().substring(0, 7)),
        double.parse(frcity_longitude.toString().substring(0, 7)),
        currentLoc.latitude,
        currentLoc.longitude);
    var displacement = double.parse(displacementString);
    var timedifference = findTimeDifference(picDate);

    if (displacement < 1 && timedifference < 10) {
      startTask(id);
    }
  }

  Future startTask(id) async {
    Map<String, String> headers = {};
    SharedPreferences sharedPreferences;
    String access_token;

    final String startTaskUrl =
        'https://hotel.bicoders.com/api/MobDriverDetails/UpdatePicStatus';

    sharedPreferences = await SharedPreferences.getInstance();
    access_token = sharedPreferences.getString('access_token');
    var currentId = sharedPreferences.getString('currentTaskId');

    print("access_token");
    print(access_token);

    headers['authorization'] = "bearer " + access_token;
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['No-Auth'] = "true";

    print("id is");
    print(id);

    dynamic startTaskBody = {
      'ID': id.toString(),
    };

    check().then((intenet) async {
      if (intenet != null && intenet && currentId == null) {
        var getAssignedDriverListResponse = await http.post(
            Uri.encodeFull(startTaskUrl),
            headers: headers,
            body: startTaskBody);

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

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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

  Future<LatLng> _getLocation() async {
    try {
      LocationData currentLocation = await location.getLocation();
      print("longitude");
      print(currentLocation.longitude);
      setState(() {
        pinPosition =
            LatLng(currentLocation.longitude, currentLocation.latitude);
      });
      return pinPosition;
    } catch (e) {
      return null;
    }
  }

  int findTimeDifference(DateTime picDate) {
    var now = new DateTime.now();
    int difference = now.difference(picDate).inMinutes;
    return difference;
  }
}
