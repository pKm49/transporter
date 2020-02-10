import 'package:flutter/material.dart';
import 'package:transporter/admin/adminalltasks.dart';
import 'package:transporter/admin/adminreport.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  TabController adminDashboardTabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminDashboardTabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: adminDashboardTabController,
          tabs: [
            Tab(text: "All Tasks"),
            Tab(text: "Report"),
          ],
        ),
        centerTitle: true,
        title: Text('Transporter'),
      ),
      body: TabBarView(
        controller: adminDashboardTabController,
        children: [
          AdminAllTasks(),
          AdminReport(),
        ],
      ),
    );
  }
}
