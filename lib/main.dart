import 'package:flutter/material.dart';
import 'package:monies/widgets/baseWidgets.dart';
import 'package:monies/widgets/dashboard.dart';
import 'package:monies/widgets/expensesList.dart';
import 'package:monies/widgets/settings.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  App();

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final initialTabIndex = 1;
  var appBarTitle = "";

  setAppBarTitle(String title) {
    setState(() {
      appBarTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = [
      Dashboard(),
      ExpensesList(),
      Settings(),
    ];

    //Initialize app bar title for first usage after launching the app
    appBarTitle = appBarTitle.length == 0
        ? (tabViews[initialTabIndex] as WidgetWithTitle).title
        : appBarTitle;

    return MaterialApp(
      title: 'monies',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(
        initialIndex: initialTabIndex,
        length: tabViews.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (tabIndex) =>
                  setAppBarTitle((tabViews[tabIndex] as WidgetWithTitle).title),
              tabs: [
                Tab(icon: Icon(Icons.insert_chart)),
                Tab(icon: Icon(Icons.payment)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text(appBarTitle),
          ),
          body: Center(
            child: TabBarView(children: tabViews),
          ),
        ),
      ),
    );
  }
}
