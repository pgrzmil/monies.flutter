import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/data/models/expense.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  final Expense expense;
  final GlobalKey<FormState> formKey;

  ExpenseForm(this.expense, this.formKey);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final dateTextController = TextEditingController();
  DateTime pickedDate;
  ExpenseCategory pickedCategory;

  @override
  void initState() {
    super.initState();
    dateTextController.text = widget.expense.dateString;
  }

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController = MoneyMaskedTextController(initialValue: widget.expense.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");
    final isEmptyValidator = (value) => value.isEmpty ? "Enter value" : null;

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
                  validator: isEmptyValidator,
                  decoration: InputDecoration(labelText: "Expense title"),
                  onSaved: (value) => widget.expense.title = value,
                ),
                TextFormField(
                  key: Key("locationField"),
                  initialValue: widget.expense.location,
                  validator: isEmptyValidator,
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
                TextFormField(
                  key: Key("dateField"),
                  controller: dateTextController,
                  validator: isEmptyValidator,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Date"),
                  onTap: () => _selectDate(context),
                  onSaved: (value) {
                    if (pickedDate != null) {
                      widget.expense.date = pickedDate;
                    }
                  },
                ),
                Consumer<CategoriesProvider>(builder: (context, provider, child) {
                  if (pickedCategory == null) pickedCategory = provider.getBy(id: widget.expense.categoryId);
                  return DropdownButtonFormField<ExpenseCategory>(
                    key: Key("categoryDropDown"),
                    decoration: InputDecoration(labelText: "Category"),
                    value: pickedCategory,
                    validator: (value) => value == null ? "Pick category" : null,
                    onChanged: (ExpenseCategory newValue) {
                      setState(() {
                        pickedCategory = newValue;
                      });
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

  _selectDate(BuildContext context) async {
    final date = await showDatePicker(
        context: context, initialDate: widget.expense.date ?? DateTime.now(), firstDate: DateTime(2019), lastDate: DateTime(2101));
    if (date != null) {
      setState(() {
        pickedDate = date;
        dateTextController.text = DateFormat('dd-MM-yyyy').format(date);
      });
    }
  }
}

