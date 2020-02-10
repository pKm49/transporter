import 'package:flutter/material.dart';

class AdminTaskDetails extends StatefulWidget {
  @override
  _AdminTaskDetailsState createState() => _AdminTaskDetailsState();
}

class _AdminTaskDetailsState extends State<AdminTaskDetails> {
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
              Text(
                "Passenger Name",
                textScaleFactor: 1.3,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Date and Time",
                textScaleFactor: 1,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
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
            ],
          ),
        ),
        bottomSheet: Container(
            width: deviceWidth,
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
                    "Confirm",
                    textScaleFactor: 1.2,
                  ),
                ),
              ),
            )));
  }
}
