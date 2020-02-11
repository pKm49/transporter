import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverAcceptedSingleTask extends StatefulWidget {
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

  DriverAcceptedSingleTask({
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
  _DriverAcceptedSingleTaskState createState() =>
      _DriverAcceptedSingleTaskState();
}

class _DriverAcceptedSingleTaskState extends State<DriverAcceptedSingleTask> {
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
                        onPressed: () {},
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
}
