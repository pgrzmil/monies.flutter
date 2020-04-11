import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/services/signInService.dart';
import 'package:provider/provider.dart';
import 'categoryForm.dart';

class CategoryAddView extends StatefulWidget {
  @override
  _CategoryAddViewState createState() => _CategoryAddViewState(formKey: GlobalKey<FormState>());
}

class _CategoryAddViewState extends State<CategoryAddView> {
  final GlobalKey<FormState> formKey;

  _CategoryAddViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<SignInService>(context, listen: false).userId;
    final ExpenseCategory category = ExpenseCategory.empty(userId);
    final categoryForm = CategoryForm(category: category, formKey: formKey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add category"),
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
            Provider.of<CategoriesProvider>(context, listen: false).add(category);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
