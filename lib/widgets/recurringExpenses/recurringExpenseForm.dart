import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';

class RecurringExpenseForm extends StatelessWidget {
  final RecurringExpense recurringExpense;
  final GlobalKey<FormState> formKey;

  const RecurringExpenseForm({Key key, this.formKey, this.recurringExpense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController =
        MoneyMaskedTextController(initialValue: recurringExpense.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            key: Key("titleField"),
            initialValue: recurringExpense.title,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Expense title", labelStyle: TextStyle(color: Theme.of(context).textTheme.caption.color)),
            onSaved: (value) => recurringExpense.title = value,
          ),
          TextFormField(
            key: Key("locationField"),
            initialValue: recurringExpense.location,
            decoration: InputDecoration(labelText: "Location", labelStyle: TextStyle(color: Theme.of(context).textTheme.caption.color)),
            onSaved: (value) => recurringExpense.location = value,
          ),
          TextFormField(
            key: Key("amountField"),
            decoration: InputDecoration(labelText: "Amount", labelStyle: TextStyle(color: Theme.of(context).textTheme.caption.color)),
            keyboardType: TextInputType.number,
            controller: moneyFormatController,
            onSaved: (value) => recurringExpense.amount = moneyFormatController.numberValue ?? 0,
          ),
          DatePickerTextFormField(
            key: Key("dateField"),
            initialDate: recurringExpense.startDate,
            dateFormatter: Format.date,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Start date", labelStyle: TextStyle(color: Theme.of(context).textTheme.caption.color)),
            onDatePicked: (date) => recurringExpense.startDate = date,
          ),
          CategoryPickerFormField(
            key: Key("categoryDropDown"),
            initialCategoryId: recurringExpense.categoryId,
            decoration: InputDecoration(labelText: "Category", labelStyle: TextStyle(color: Theme.of(context).textTheme.caption.color)),
            validator: Validator.notNull("Pick category"),
            onCategoryPicked: (category) => recurringExpense.categoryId = category.id,
          ),
        ],
      ),
    );
  }
}
