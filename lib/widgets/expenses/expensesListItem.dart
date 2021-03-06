import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense.dart';

class ExpensesListItem extends StatelessWidget {
  final Expense expense;

  ExpensesListItem({this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Consumer<CategoriesProvider>(builder: (_, categoriesProvider, __) {
              final category = categoriesProvider.getBy(id: expense.categoryId);
              return CategoryIcon(category: category);
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 235),
                    padding: EdgeInsets.only(right: 6),
                    child: Text(
                      expense.displayTitle,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (expense.recurringExpenseId != null && expense.recurringExpenseId.isNotEmpty)
                    Icon(Icons.refresh, size: 17, color: Theme.of(context).textTheme.title.color),
                ],
              ),
              Text(expense.dateString),
            ],
          ),
          Spacer(),
          Text(expense.amountString),
        ],
      ),
    );
  }
}
