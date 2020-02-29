import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:provider/provider.dart';

typedef void CategoryPickingCallback(ExpenseCategory category);

class CategoryPickerFormField extends StatefulWidget {
  final String initialCategoryId;
  final CategoryPickingCallback onCategoryPicked;
  final InputDecoration decoration;
  final FormFieldValidator<ExpenseCategory> validator;

  const CategoryPickerFormField({Key key, this.onCategoryPicked, this.decoration, this.validator, this.initialCategoryId}) : super(key: key);

  @override
  _CategoryPickerFormFieldState createState() => _CategoryPickerFormFieldState();
}

class _CategoryPickerFormFieldState extends State<CategoryPickerFormField> {
  ExpenseCategory pickedCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(builder: (context, provider, child) {
      if (pickedCategory == null) {
        pickedCategory = provider.getBy(id: widget.initialCategoryId);
      }

      return DropdownButtonFormField<ExpenseCategory>(
        decoration: widget.decoration,
        value: pickedCategory,
        validator: widget.validator,
        onChanged: (ExpenseCategory newValue) {
          setState(() => pickedCategory = newValue);
        },
        items: provider.getAll().map<DropdownMenuItem<ExpenseCategory>>((ExpenseCategory value) {
          return DropdownMenuItem<ExpenseCategory>(value: value, child: Text(value.title), key: Key(value.id));
        }).toList(),
        onSaved: (value) {
          if (pickedCategory != null && widget.onCategoryPicked != null) {
            widget.onCategoryPicked(pickedCategory);
          }
        },
      );
    });
  }
}
