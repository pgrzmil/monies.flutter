import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';

class CategoriesListItem extends StatelessWidget {
  final ExpenseCategory category;
  final void Function() onTap;
  CategoriesListItem({this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: category?.color ?? Colors.deepPurple[500],
          child: Icon(
            category?.icon ?? Icons.attach_money,
            color: Colors.white,
          ),
        ),
        title: Text(category.title),
        onTap: onTap,
      ),
    );
  }
}
