import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/widgets/settings.dart';
import 'package:provider/provider.dart';

import 'expenses/expensesList.dart';
import 'expenses/expensesListItem.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var selectedDate = DateTime.now();
  String get title {
    return DateFormat.MMMM().add_y().format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(builder: (context, expensesProvider, _) {
      final lastExpenses = expensesProvider.getLatest(3, selectedDate.month, selectedDate.year);
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              FlatButton(
                child: Icon(Icons.arrow_left),
                onPressed: () { setState(() {
                  selectedDate = Jiffy(selectedDate).subtract(months: 1);
                });
                },
              ),
              Text(title),
              FlatButton(
                child: Icon(Icons.arrow_right),
                onPressed: () { setState(() {
                  selectedDate = Jiffy(selectedDate).add(months: 1);
                });},
              ),
            ]),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //dashboard component
            Center(
              child: Column(
                children: [Text("Expenses sum")],
              ),
            ),

            //Expenses component
            Card(
              child: InkWell(
                child: Column(
                  children: [
                    Text("Expenses"),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lastExpenses.length,
                      padding: EdgeInsets.only(bottom: 5),
                      separatorBuilder: (context, index) => Divider(height: 5),
                      itemBuilder: (context, index) {
                        return ExpensesListItem(lastExpenses[index]);
                      },
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesList(selectedDate: selectedDate,))),
              ),
            ),

            //analytics component
            Card(
              child: Column(
                children: [
                  Text("Analytics"),
                  SizedBox(height: 100, width: 100, child: Icon(Icons.pie_chart)),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
