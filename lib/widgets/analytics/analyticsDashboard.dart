import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monies/data/analyticsProvider.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoriesListItem.dart';
import 'package:monies/widgets/controls/donutChart.dart';
import 'package:monies/widgets/controls/swipeable.dart';
import 'package:monies/widgets/expenses/expensesList.dart';
import 'package:provider/provider.dart';

class AnalyticsDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analyticsProvider, _) {
        final sumByCategories = analyticsProvider.sumByCategory;
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: Row(
              //Month selector widget
              children: [
                SizedBox(
                  child: FlatButton(
                    child: Icon(Icons.arrow_left, color: Theme.of(context).textTheme.title.color),
                    onPressed: analyticsProvider.switchToPreviousMonth,
                  ),
                  width: 40,
                ),
                Text(analyticsProvider.title.toUpperCase()),
                SizedBox(
                  child: FlatButton(
                    child: Icon(Icons.arrow_right, color: Theme.of(context).textTheme.title.color),
                    onPressed: analyticsProvider.switchToNextMonth,
                  ),
                  width: 40,
                ),
              ],
            ),
          ),
          body: Swipeable(
            onLeftSwipe: analyticsProvider.switchToNextMonth,
            onRightSwipe: analyticsProvider.switchToPreviousMonth,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 300,
                  width: 400,
                  child: DonutPieChart(analyticsProvider.categoriesChartData, animate: true),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: sumByCategories.length,
                  separatorBuilder: (context, index) => Divider(height: 0),
                  itemBuilder: (context, index) {
                    final item = sumByCategories.elementAt(index);
                    return InkWell(
                      child: CategoriesListItem(
                        category: item.category,
                        trailing: Text(Format.money(item.sum)),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ExpensesList(selectedDate: analyticsProvider.currentDate, categoryFilter: item.category.id))),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
