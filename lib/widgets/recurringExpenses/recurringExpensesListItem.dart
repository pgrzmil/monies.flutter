import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';
import 'package:provider/provider.dart';

class RecurringExpensesListItem extends StatelessWidget {
  final RecurringExpense recurringExpense;

  const RecurringExpensesListItem({Key key, this.recurringExpense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Consumer<CategoriesProvider>(builder: (_, categoriesProvider, __) {
              final category = categoriesProvider.getBy(id: recurringExpense.categoryId);
              return CategoryIcon(category: category);
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 250),
                  padding: EdgeInsets.only(right: 6),
                  child: Text(
                    recurringExpense.displayTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]),
              Text(recurringExpense.startDateString),
            ],
          ),
          Spacer(),
          Text(recurringExpense.amountString),
        ],
      ),
    );
  }
}
