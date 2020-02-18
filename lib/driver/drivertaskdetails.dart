import 'dart:convert';
import 'dart:math';

import 'package:bicoders_transporter/mapview.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverTaskDetails extends StatefulWidget {
  @override
  _DriverTaskDetailsState createState() => _DriverTaskDetailsState();
}

class _DriverTaskDetailsState extends State<DriverTaskDetails> {
  var id,
      guestName,
      picDate,
      frCityId,
      lFrom,
      toCityId,
      lTo,
      trTp,
      flight,
      flightDetails,
      qty,
      adult,
      child,
      frcity_Longitude,
      frcity_Latitude,
      tocity_Longitude,
      tocity_Latitude;

  PermissionStatus permissionStatus;
  var location ;
  LatLng pinPosition;
  String tranType ;
  var formatedPicDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          guestName = taskDetailsResponseBody["GUEST_NAME"];
          picDate = taskDetailsResponseBody["PICDATE"];
          frCityId = taskDetailsResponseBody["FRCITYID"];
          lFrom = taskDetailsResponseBody["LFROM"];
          toCityId = taskDetailsResponseBody["TOCITYID"];
          lTo = taskDetailsResponseBody["LTO"];
          trTp = taskDetailsResponseBody["TRTP"];
          flight = taskDetailsResponseBody["FLIGHT"];
          flightDetails = taskDetailsResponseBody["FLIGHTDETAILS"];
          qty = taskDetailsResponseBody["QTY"];
          adult = taskDetailsResponseBody["ADULT"];
          child = taskDetailsResponseBody["CHILD"];
          frcity_Longitude = taskDetailsResponseBody["FRCITY_LONGITUDE"];
          frcity_Latitude = taskDetailsResponseBody["FRCITY_LATITUDE"];
          tocity_Longitude = taskDetailsResponseBody["TOCITY_LONGITUDE"];
          tocity_Latitude = taskDetailsResponseBody["TOCITY_LATITUDE"];

          picDate = DateTime.parse(
            picDate,
          );

         var format = new DateFormat.yMd().add_jm();

          formatedPicDate = format.format(picDate);

          tranType = getTrantype(trTp);
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

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Transporter'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          height: deviceHeight * .8,
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: id==null?false:true,
                child: Container(
                  height: deviceHeight * .8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        guestName,
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
                                lFrom + "," + frCityId,
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
                                lTo + "," + toCityId,
                                textScaleFactor: 1.5,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              )),
                        ],
                      ),
                      SizedBox(height: 6),
                      Visibility(
                          visible: true,
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
                      Visibility(visible: true, child: SizedBox(height: 6)),
                      Visibility(
                          visible: getFlightVisibility(true, trTp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Flight Number :",
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                flight,
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Visibility(visible: true, child: SizedBox(height: 6)),
                      Visibility(
                          visible: getFlightVisibility(true, trTp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Flight Details :",
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getString(flightDetails),
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Visibility(visible: true, child: SizedBox(height: 6)),
                      Visibility(
                          visible: getFlightVisibility(true, trTp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Number of Passengers :",
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getString(qty),
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Visibility(visible: true, child: SizedBox(height: 6)),
                      Visibility(
                          visible: getFlightVisibility(true, trTp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Number of Adults :",
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getString(adult),
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Visibility(visible: true, child: SizedBox(height: 6)),
                      Visibility(
                          visible: getFlightVisibility(true, trTp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Number Of Childern :",
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                getString(child),
                                textScaleFactor: 1.3,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      Visibility(visible: true, child: SizedBox(height: 6)),
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MapView()));
                                    },
                                    shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5.0)),
                                    child: new Text(
                                      "View Map",
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
                                      finishRide(id, tocity_Latitude,
                                          tocity_Longitude);
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
                        ],
                      )

                    ],
                  ),
                ),
              ),
              Visibility(
                visible: id == null ? true : false,
                child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .90,
                    child: Text(
                      'No Tasks',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    )),
              ),
            ],
          ),
        ),);
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


  Future finishRide(id,
      tocity_latitude, tocity_longitude) async {
    LatLng currentLoc = await _getLocation();
    print("latitude");
    var displacementString = distance(
        double.parse(tocity_latitude.toString().substring(0, 7)),
        double.parse(tocity_longitude.toString().substring(0, 7)),
        currentLoc.latitude,
        currentLoc.longitude);
    var displacement = double.parse(displacementString);

    if (displacement < 1 ) {
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

}
