import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monies/widgets/dashboard/dashboard.dart';
import 'package:monies/widgets/login.dart';

class Routes {
  static final dashboard = "dashboard";
  static final login = "/login";

  static Map<String, WidgetBuilder> get navigationRoutes => {
        dashboard: (BuildContext context) => Dashboard(),
        login: (BuildContext context) => LoginPage(),
      };
}

Future<T> pushTo<T extends Object>(BuildContext context, Widget widget) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}
