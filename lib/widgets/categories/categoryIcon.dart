import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';

class CategoryIcon extends StatelessWidget {
  final ExpenseCategory category;

  const CategoryIcon({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: category?.color ?? ExpenseCategory.defaultColor,
      child: Icon(
        category?.icon ?? ExpenseCategory.defaultIcon,
        color: Colors.white,
      ),
    );
  }
}
