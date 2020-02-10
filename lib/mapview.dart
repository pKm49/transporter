import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  PermissionStatus permissionStatus;
  var location = new Location();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Map<String, Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPermission();
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
            target: LatLng(10.8505, 76.2711),
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
                          onPressed: () {},
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
                            onPressed: () {},
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
      //    _getLocation();

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

  Future<Map<String, double>> _getLocation() async {
    var currentLocation = <String, double>{};
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
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
}
