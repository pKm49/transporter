import 'package:flutter/material.dart';
import 'package:transporter/driver/driverascceptedtasks.dart';
import 'package:transporter/driver/driverassignedtasks.dart';
import 'package:transporter/driver/driverreport.dart';

class DriverDashboard extends StatefulWidget {
  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard>
    with SingleTickerProviderStateMixin {
  //Declare Tabcontroller
  TabController driverDashboardTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverDashboardTabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: driverDashboardTabController,
          tabs: [
            Tab(text: "Assigned Tasks"),
            Tab(text: "Accepted Tasks"),
            Tab(text: "Report"),
          ],
        ),
        centerTitle: true,
        title: Text('Transporter'),
      ),
      body: TabBarView(
        controller: driverDashboardTabController,
        children: [
          DriverAssignedTasks(),
          DriverAcceptedTasks(),
          DriverReport(),
        ],
      ),
    );
  }
}
