import 'package:flutter/material.dart';

import 'baseWidgets.dart';

class Dashboard extends StatelessWidget implements WidgetWithTitle {
  @override
  String get title => "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Container(child: Tab(icon: Icon(Icons.insert_chart)));
  }
}
