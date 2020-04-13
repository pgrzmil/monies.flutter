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

  const CategoryPickerFormField({
    Key key,
    this.onCategoryPicked,
    this.decoration,
    this.validator,
    this.initialCategoryId,
  }) : super(key: key);

  @override
  _CategoryPickerFormFieldState createState() => _CategoryPickerFormFieldState(initialCategoryId);
}

class _CategoryPickerFormFieldState extends State<CategoryPickerFormField> {
  ExpenseCategory pickedCategory;
  
  /// Stores initial category set to widget. 
  /// When initial category changes in parent widget (e.g when recurring expense is reset) it will be different 
  /// from [widget.initialCategoryId] and  because of that [pickedCategory] field will be updated  in [build] method. 
  /// It's a hack and potentially should be fixed in the future.
  String initialCategoryId; 

  _CategoryPickerFormFieldState(String initialCategoryId) {
    this.initialCategoryId = initialCategoryId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(builder: (context, provider, child) {
      if (pickedCategory == null || initialCategoryId != widget.initialCategoryId) {
        pickedCategory = provider.getBy(id: widget.initialCategoryId);
        initialCategoryId = widget.initialCategoryId;
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
