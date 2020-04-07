import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/widgets/dashboard/dashboard.dart';
import 'package:monies/widgets/login.dart';
import 'package:provider/provider.dart';

class Routes {
  static final dashboard = "/dashboard";
  static final login = "/login";
  static final splash = "/splash";

  static Map<String, WidgetBuilder> get navigationRoutes => {
        dashboard: (BuildContext context) => Dashboard(),
        login: (BuildContext context) => LoginPage(),
      };
}

Future<T> pushTo<T extends Object>(BuildContext context, Widget widget) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
}

Future popLogin<T extends Object>(BuildContext context) async {
  final service = Provider.of<SignInService>(context, listen: false);
  final isLoggedIn = await service.isLoggedIn;
  await Navigator.of(context).pop();
  if (!isLoggedIn) {
    await Navigator.pushNamed(context, Routes.login);
  }
}
