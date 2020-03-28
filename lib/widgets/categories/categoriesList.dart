import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/widgets/categories/categoryForm.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/formSheetContent.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'categoriesListItem.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final userId = Provider.of<SignInService>(context, listen: false).userId;
        return ItemsList<ExpenseCategory>(
          items: categoriesProvider.getAll(),
          title: "Categories",
          onAdd: () => _showEditSheet(context, ExpenseCategory.empty(userId), onSave: (category) => categoriesProvider.add(category)),
          onEdit: (category) => _showEditSheet(context, category, onSave: (category) => categoriesProvider.edit(category)),
          onCellTap: (category) => _showEditSheet(context, category, onSave: (category) => categoriesProvider.edit(category)),
          onRefresh: categoriesProvider.refresh,
          onRemove: (category) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove category?")) {
              await categoriesProvider.remove(category);
            }
          },
          onCellCreate: (category) => CategoriesListItem(category: category),
        );
      },
    );
  }

  _showEditSheet(BuildContext context, ExpenseCategory category, {Function(ExpenseCategory category) onSave}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FormSheetContent(
          formBuilder: (formKey) => CategoryForm(formKey: formKey, category: category),
          onSave: () => onSave(category),
        );
      },
    );
  }
}
