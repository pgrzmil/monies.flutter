import 'package:flutter/material.dart';

import 'baseWidgets.dart';

class Settings extends StatelessWidget implements WidgetWithTitle {
  @override
  String get title => "Settings";

  @override
  Widget build(BuildContext context) {
    return Container(child: Tab(icon: Icon(Icons.settings)));
  }
}
