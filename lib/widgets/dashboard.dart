import 'package:flutter/material.dart';

import 'baseWidgets.dart';

class Dashboard extends StatefulWidget implements WidgetWithTitle {
  @override
  _DashboardState createState() => _DashboardState();

  @override
  String get title => "Dashboard";
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Tab(icon: Icon(Icons.insert_chart)));
  }
}
