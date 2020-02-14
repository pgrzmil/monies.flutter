import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  final Expense expense;
  final GlobalKey<FormState> formKey;

  ExpenseForm(this.expense, this.formKey);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  ExpenseCategory pickedCategory;

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController =
        MoneyMaskedTextController(initialValue: widget.expense.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");

    return Card(
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  key: Key("titleField"),
                  initialValue: widget.expense.title,
                  validator: Validator.notEmpty(),
                  decoration: InputDecoration(labelText: "Expense title"),
                  onSaved: (value) => widget.expense.title = value,
                ),
                TextFormField(
                  key: Key("locationField"),
                  initialValue: widget.expense.location,
                  validator: Validator.notEmpty(),
                  decoration: InputDecoration(labelText: "Location"),
                  onSaved: (value) => widget.expense.location = value,
                ),
                TextFormField(
                  key: Key("amountField"),
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                  controller: moneyFormatController,
                  onSaved: (value) => widget.expense.amount = moneyFormatController.numberValue ?? 0,
                ),
                DatePickerTextFormField(
                  key: Key("dateField"),
                  initialDate: widget.expense.date,
                  dateFormatter: Format.date,
                  validator: Validator.notEmpty(),
                  decoration: InputDecoration(labelText: "Date"),
                  onDatePicked: (date) => widget.expense.date = date,
                ),
                Consumer<CategoriesProvider>(builder: (context, provider, child) {
                  if (pickedCategory == null) pickedCategory = provider.getBy(id: widget.expense.categoryId);
                  return DropdownButtonFormField<ExpenseCategory>(
                    key: Key("categoryDropDown"),
                    decoration: InputDecoration(labelText: "Category"),
                    value: pickedCategory,
                    validator: Validator.notNull("Pick category"),
                    onChanged: (ExpenseCategory newValue) {
                      setState(() => pickedCategory = newValue);
                    },
                    items: provider.getAll().map<DropdownMenuItem<ExpenseCategory>>((ExpenseCategory value) {
                      return DropdownMenuItem<ExpenseCategory>(value: value, child: Text(value.title));
                    }).toList(),
                    onSaved: (value) {
                      if (pickedCategory != null) {
                        widget.expense.categoryId = pickedCategory.id;
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
