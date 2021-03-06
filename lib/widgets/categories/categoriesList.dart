import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'categoriesListItem.dart';
import 'package:provider/provider.dart';

import 'categoryAdd.dart';
import 'categoryEdit.dart';

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final categories = categoriesProvider.getAll();
        return ItemsList<ExpenseCategory>(
          key: PageStorageKey("CategoriesKey"),
          items: categories,
          title: "Categories".toUpperCase(),
          onAdd: () => navigateToAdd(context),
          onEdit: (category) => navigateToEdit(context, category),
          onCellTap: (category) => navigateToEdit(context, category),
          onRefresh: categoriesProvider.refresh,
          onRemove: (category) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove category?")) {
              await categoriesProvider.remove(category);
            }
          },
          onCellCreate: (category, index) => CategoriesListItem(category: category),
          onCellFooterCreate: (_, index) {
            if (index == categories.length - 1) {
              return SizedBox(height: 50);
            }
            return null;
          },
        );
      },
    );
  }

  navigateToEdit(BuildContext context, ExpenseCategory category) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryEditView(category: category)));
  }

  navigateToAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryAddView()));
  }
}
