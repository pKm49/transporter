import 'package:bicoders_transporter/driver/drivertaskdetails.dart';
import 'package:flutter/material.dart';

class AdminAllTasks extends StatefulWidget {
  @override
  _AdminAllTasksState createState() => _AdminAllTasksState();
}

class _AdminAllTasksState extends State<AdminAllTasks> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
        height: deviceHeight * .8,
        child: ListView(
          children: <Widget>[
            Container(
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
              height: deviceHeight * .2,
              margin: new EdgeInsets.all(10.0),
              padding: new EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Passenger Name",
                      textScaleFactor: 1.3,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Date and Time",
                      textScaleFactor: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: Text(
                              "From Place",
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
                              "To Place",
                              textScaleFactor: 1.5,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
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
                                            builder: (context) =>
                                                DriverTaskDetails()));
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0)),
                                  child: new Text(
                                    "View Details",
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
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0)),
                                  child: new Text(
                                    "Accept",
                                    textScaleFactor: 1.2,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
