import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverAssignedSingleTaskCopy extends StatefulWidget {
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

  DriverAssignedSingleTaskCopy({
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
  });

  @override
  _DriverAssignedSingleTaskCopyState createState() =>
      _DriverAssignedSingleTaskCopyState();
}

class _DriverAssignedSingleTaskCopyState
    extends State<DriverAssignedSingleTaskCopy> {
  bool detailsVisibility = false;

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
                          acceptTask(widget.id);
                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: new Text(
                          "Accept",
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

  Future<String> acceptTask(
    taskID,
  ) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            child: Container(
                color: Colors.transparent,
                height: 200.0,
                width: 100.0,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          );
        });
    List assignedTasks = [];

    SharedPreferences sharedPreferences;

    int assignedTasksLength;

    Map<String, String> headers = {};

    String access_token;

    final String getAssignedDriverListRequestUrl =
        'https://hotel.bicoders.com/api/MobDriverDetails/ConfirmTripByDriver';
    print("reached getAssignedDriverList");
    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences = await SharedPreferences.getInstance();
    access_token = sharedPreferences.getString('access_token');

    print("access_token");
    print(access_token);

    headers['authorization'] = "bearer " + access_token;
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['No-Auth'] = "true";

    print("taskID");
    print(taskID.toString());
    dynamic getAssignedDriverListRequestBody = {
      '': '$taskID',
    };

    check().then((intenet) async {
      if (intenet != null && intenet) {
        var getAssignedDriverListResponse = await http.post(
            Uri.encodeFull(getAssignedDriverListRequestUrl),
            headers: headers,
            body: getAssignedDriverListRequestBody);

        print("Tasks are");
        print(getAssignedDriverListResponse.body);

        var getAssignedDriverListResponseBody =
            getAssignedDriverListResponse.body.isEmpty
                ? []
                : json.decode(getAssignedDriverListResponse.body);

        setState(() {
          assignedTasks = getAssignedDriverListResponseBody;
          assignedTasksLength =
              assignedTasks == null ? 0 : assignedTasks.length;

          print("length is ");
          print(assignedTasksLength);
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
}
