import 'package:flutter/material.dart';

import 'baseWidgets.dart';
import 'dashboard.dart';
import 'expensesList.dart';
import 'settings.dart';

class RootTabView extends StatefulWidget {
  @override
  _RootTabViewState createState() => _RootTabViewState();
}

class _RootTabViewState extends State<RootTabView> with SingleTickerProviderStateMixin {
  final initialTabIndex = 1;
  final List<WidgetWithTitle> tabViews = [
    Dashboard(),
    ExpensesList(),
    Settings(),
  ];

  TabController _tabController;
  String _appBarTitle;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabViews.length, initialIndex: initialTabIndex, vsync: this);
    _tabController.addListener(handleChange);
    _appBarTitle = tabViews[initialTabIndex].title;
  }

  @override
  void dispose() {
    _tabController.removeListener(handleChange);
    _tabController.dispose();
    super.dispose();
  }

  handleChange() {
    setState(() {
      _appBarTitle = tabViews[_tabController.index].title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.insert_chart)),
            Tab(icon: Icon(Icons.payment)),
            Tab(icon: Icon(Icons.settings)),
          ],
        ),
        title: Text(_appBarTitle),
      ),
      body: Center(
        child: TabBarView(
          controller: _tabController,
          children: tabViews,
        ),
      ),
    );
  }
}
