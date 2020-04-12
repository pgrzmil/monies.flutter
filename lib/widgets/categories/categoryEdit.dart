import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:provider/provider.dart';
import 'categoryForm.dart';

class CategoryEditView extends StatefulWidget {
  final ExpenseCategory category;

  CategoryEditView({this.category});

  @override
  _CategoryEditViewState createState() => _CategoryEditViewState(formKey: GlobalKey<FormState>());
}

class _CategoryEditViewState extends State<CategoryEditView> {
  final GlobalKey<FormState> formKey;

  _CategoryEditViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final categoryForm = CategoryForm(category: widget.category, formKey: formKey);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.category.title.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to remove category?")) {
                await Provider.of<CategoriesProvider>(context, listen: false).remove(widget.category);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child:categoryForm,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = categoryForm.formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<CategoriesProvider>(context, listen: false).edit(widget.category);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
