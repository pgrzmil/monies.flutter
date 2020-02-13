import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense.dart';

class ExpensesListItem extends StatelessWidget {
  final Expense expense;

  ExpensesListItem(this.expense);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoriesProvider>(context, listen: false);
    final category = provider.getBy(id: expense.categoryId);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: CategoryIcon(category: category),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(expense.displayTitle),
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
