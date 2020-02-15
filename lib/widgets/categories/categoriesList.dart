import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/widgets/categories/categoryForm.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/formSheetContent.dart';
import 'categoriesListItem.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final slidableController = SlidableController();
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final categories = categoriesProvider.getAll();
        return Scaffold(
          appBar: AppBar(title: Text("Categories")),
          body: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (context, index) => Divider(height: 0),
            itemBuilder: (context, index) {
              final category = categories.elementAt(index);
              return Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                controller: slidableController,
                child: CategoriesListItem(
                  category: category,
                  onTap: () => _showEditSheet(context, category, onSave: (category) => categoriesProvider.edit(category)),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Remove',
                    color: Colors.redAccent,
                    icon: Icons.delete,
                    onTap: () async {
                      if (await Dialogs.confirmation(context, text: "Do you want to remove category?")) {
                        await categoriesProvider.remove(category);
                      }
                    },
                  ),
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.greenAccent,
                    icon: Icons.edit,
                    onTap: () => _showEditSheet(context, category, onSave: (category) => categoriesProvider.edit(category)),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showEditSheet(context, ExpenseCategory.empty(), onSave: (category) => categoriesProvider.add(category)),
          ),
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, ExpenseCategory category, {Function(ExpenseCategory category) onSave}) {
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
