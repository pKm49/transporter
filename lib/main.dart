import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'admin/admindashboard.dart';
import 'driver/driverdashboard.dart';
import 'loginpage.dart';

Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
  return Visibility(
    child: new CircularProgressIndicator(),
  );
}

void main() async {

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  bool isLoggedin = sharedPreferences.getBool("isLoggedin") == null
      ? false
      : sharedPreferences.getBool("isLoggedin");

  print("isLoggedin");
  print(isLoggedin);

  String userType = sharedPreferences.getString("userType");

//  SystemChrome.setSystemUIOverlayStyle(
//      SystemUiOverlayStyle(statusBarColor: Colors.blue // status bar color
//          ));
//  ErrorWidget.builder = (errorDetails) {
//    return Container(
//        child: Center(
//      child: CircularProgressIndicator(),
//    ));
//  };

//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown,
//  ]);

  runApp(MaterialApp(
      title: "Transporter",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
     debugShowCheckedModeBanner: false,
      home: isLoggedin
          ? (userType == "driver" ? DriverDashboard() : AdminDashboard())
          : LoginPage())
  );
}
