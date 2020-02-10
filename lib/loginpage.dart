import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transporter/admin/admindashboard.dart';
import 'package:transporter/driver/driverdashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Declare Sharedpreference Variable
  SharedPreferences sharedPreferences;
  String dropdownValue = "one";
  //Text controllers
  TextEditingController userIdController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Declare headers
  Map<String, String> headers = {};

  //Declare login form key
  final _loginFormKey = GlobalKey<FormState>();

  //Declare global variable to store userId and password
  var userId;
  var password;

  //Declare global variable to store userType, loginStatus and driverCode
  String userType;
  bool isLoggedin;
  int driverID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      child: Padding(
          padding: new EdgeInsets.all(35.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.8,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'UserID',
                    contentPadding: new EdgeInsets.all(20.0),
                    fillColor: Colors.white,
                    errorBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                    //fillColor: Colors.green
                  ),
                  controller: userIdController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter UserID';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 25.0),
                TextFormField(
                  decoration: new InputDecoration(
                    hintText: 'Password',
                    contentPadding: const EdgeInsets.all(20.0),
                    fillColor: Colors.white,
                    errorBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(color: Colors.red, width: 1.5),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide:
                          new BorderSide(color: Colors.black, width: 1.5),
                    ),
                    //fillColor: Colors.green
                  ),
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.0),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ButtonTheme(
                  minWidth: deviceWidth,
                  height: 60.0,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        getLoginData();
                      }
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    child: new Text(
                      "Login",
                      textScaleFactor: 1.2,
                    ),
                  ),
                )
              ],
            ),
          )),
    ));
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

  void getLoginData() async {
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

    check().then((internet) async {
      if (internet != null && internet) {
        userId = userIdController.text;
        password = passwordController.text;

        print("userId");
        print(userId);
        print(password);

        dynamic loginRequestBody = {
          'UserId': userId,
          'Password': password,
        };

        headers['Accept'] = "application/JSON";

        http.Response loginResponse = await http.post(
            "https://hotel.bicoders.com/api/ApplicationLoginUser/LoginData",
            headers: headers,
            body: loginRequestBody);

        print("loginResponse");
        print(loginResponse.body);

        if (loginResponse.body == 'null') {
          Navigator.of(context).pop();

          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text("No User found!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          var userData = json.decode(loginResponse.body);

          int workingDepartment = userData["WorkingDepartment"];

          driverID = userData["DriverID"];

          if (workingDepartment == 6) {
            userType = "driver";
          } else {
            userType = "admin";
          }

          print("userType");
          print(userType);

          getTocken();
        }

        // Internet Present Case
      } else {
        Navigator.of(context).pop();
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
                  },
                ),
              ],
            );
          },
        );
      }
      // No-Internet Case
    });
  }

  void getTocken() async {
    check().then((internet) async {
      if (internet != null && internet) {
        dynamic getTockenRequestBody = {
          'username': userId,
          'password': password,
          'grant_type': 'password'
        };

        headers['Accept'] = "application/JSON";

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        http.Response getTockenResponse = await http.post(
            "https://hotel.bicoders.com/token",
            headers: headers,
            body: getTockenRequestBody);

        print("tocken response");
        print(getTockenResponse.body);

        if (getTockenResponse.body == 'null') {
          Navigator.of(context).pop();
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm'),
                content: Text("Are You sure?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          var getTockenResponseBody = json.decode(getTockenResponse.body);

          String access_token = getTockenResponseBody["access_token"];
          print("tocken");
          print(access_token);

          sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setBool("isLoggedin", true);
          sharedPreferences.setString("userType", userType);
          sharedPreferences.setString("access_token", access_token);
          sharedPreferences.setInt("driverID", driverID);
          Navigator.of(context).pop();

          userType == "driver"
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DriverDashboard()))
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()));
        }

        // Internet Present Case
      } else {
        Navigator.of(context).pop();
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
                  },
                ),
              ],
            );
          },
        );
      }
      // No-Internet Case
    });
  }
}
