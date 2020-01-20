import 'package:flutter/material.dart';

import 'baseWidgets.dart';

class Settings extends StatefulWidget implements WidgetWithTitle {
  @override
  _SettingsState createState() => _SettingsState();

  @override
  String get title => "Settings";
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Tab(icon: Icon(Icons.settings)));
  }
}
