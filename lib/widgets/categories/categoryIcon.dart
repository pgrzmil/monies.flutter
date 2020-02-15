import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';

class CategoryIcon extends StatelessWidget {
  final ExpenseCategory category;
  final double radius;
  final Color color;
  final IconData icon;
  
  const CategoryIcon({Key key, this.category, this.radius, this.color, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color ?? category?.color ?? ExpenseCategory.defaultColor,
      child: Icon(
        icon ?? category?.icon ?? ExpenseCategory.defaultIcon,
        color: Colors.white,
      ),
    );
  }
}
