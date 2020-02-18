import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/driverassignedsingletask.dart';

class DriverAssignedTasks extends StatefulWidget {
  @override
  _DriverAssignedTasksState createState() => _DriverAssignedTasksState();
}

class _DriverAssignedTasksState extends State<DriverAssignedTasks> {
  List assignedTasks = [];

  SharedPreferences sharedPreferences;

  String taskID;

  int assignedTasksLength;

  Map<String, String> headers = {};

  String access_token;

  final int driverId = 10;

  final String getAssignedDriverListRequestUrl =
      'https://hotel.bicoders.com/api/MobDriverDetails/GetAssignedDriverList';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAssignedDriverList();
  }

  Future<String> getAssignedDriverList() async {
    print("reached getAssignedDriverList");
    sharedPreferences = await SharedPreferences.getInstance();
    access_token = sharedPreferences.getString('access_token');

    print("access_token");
    print(access_token);

    headers['authorization'] = "bearer " + access_token;
    headers['Content-Type'] = "application/x-www-form-urlencoded";
    headers['No-Auth'] = "true";

    dynamic getAssignedDriverListRequestBody = {
      'DriverId': '$driverId',
      'Accept': '0',
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

  /*

  {
        "IDD": 15,  document id
        "RESIDD": 4, Reservation Id
        "GUEST_NAME": "Abdullah Ahmed", Name of the Guest
        "GUEST_LOCAL_MOBILE": "1234",  Mobile NUmber of the guest
        "GUEST_TELP": "",
        "AGNAME": "I AM TRAVEL",  Agent Name
        "PICDATE": "2008-04-29T12:25:00",  Pickup Date and Time
        "ROUTE_NAME": null,
        "FRCITYID": "JED",  Name of City ( from )
        "LFROM": "Jed Int'l Airport",  Location From
        "TOCITYID": "MAK",  Name of City ( To )
        "LTO": "Manazil Al Abrar..",  Location To
        "TRTP": 0",   Transportation Type ( Arrival - 0, Departure -1, Internal - 2)
        "FLIGHT": "GF 171",  Flight Number
        "VEC_NAME": "CAPRICE",  Vehicle Name
        "COMPNAME": "Al Jazeera Transport",  Company Name
        "QTY": 1,  Total Number of Passengers
        "ADULT": 4, Number of Adult
        "CHILD": 0, Number of Child
        "PICNAME": "Abdul Latif # 42",  Name of Driver
        "MOB": "0551234522", Mobile Number
        "BOARDNO": null,
        "VHID": 0,
        "REMARK": "",
        "AIDD": 24,
        "VHNO": null,
        "AGREFNO": "",
        "IDNO": "116"
    },



if no accept is passed
  all
if accept = 1
  only accepted
if accept = 0
  not accepted


   */

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Visibility(
            visible: assignedTasksLength == null || assignedTasksLength == 0
                ? false
                : true,
            child: Container(
                height: MediaQuery.of(context).size.height * .8,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: assignedTasksLength,
                  itemBuilder: (BuildContext context, int index) {
                    return DriverAssignedSingleTask(
                      id: assignedTasks[index]['IDD'],
                      guestName: assignedTasks[index]['GUEST_NAME'],
                      picDate: assignedTasks[index]['PICDATE'],
                      frCityId: assignedTasks[index]['FRCITYID'],
                      lFrom: assignedTasks[index]['LFROM'],
                      toCityId: assignedTasks[index]['TOCITYID'],
                      lTo: assignedTasks[index]['LTO'],
                      trTp: assignedTasks[index]['TRTP'],
                      flight: assignedTasks[index]['FLIGHT'],
                      flightDetails: assignedTasks[index]['FLIGHTDETAILS'],
                      qty: assignedTasks[index]['QTY'],
                      adult: assignedTasks[index]['ADULT'],
                      child: assignedTasks[index]['CHILD'],
                    );
                  },
                ))),
        Visibility(
          visible: assignedTasksLength == 0 ? true : false,
          child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .90,
              child: Text(
                'No Tasks Assigned Yet',
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              )),
        ),
        Visibility(
          visible: assignedTasksLength == null ? true : false,
          child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .90,
              child: Text(
                'Loading....',
                textAlign: TextAlign.center,
                textScaleFactor: 1.5,
              )),
        )
      ],
    );
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
