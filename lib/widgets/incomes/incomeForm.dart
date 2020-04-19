import 'package:flutter/material.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/data/models/incomeType.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/expressionKeyboard.dart';
import 'package:monies/widgets/controls/moniesDropdownButtonFormField.dart';
import 'package:monies/widgets/controls/moniesForm.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class IncomeForm extends StatelessWidget {
  final Income income;
  final GlobalKey<FormState> formKey;

  IncomeForm({Key key, this.formKey, this.income}) : super(key: key) {
    amountController.text = income.amountExpression;
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MoniesForm(
      formKey: formKey,
      child: MathExpressionKeyboard(
        targetFocusNode: _amountFocus,
        targetTextController: amountController,
        child: Column(
          children: [
            MoniesDropdownButtonFormField<IncomeType>(
              hint: Text("Income type", style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.title.color)),
              initialValue: income.type ?? IncomeType.other,
              // onChanged: ((type) {}),
              items: dropdownItems,
              validator: Validator.notNull(),
              decoration: InputDecoration(labelText: "Income type"),
              onSaved: (value) => income.type = value,
            ),
            MoniesTextFormField(
              context,
              key: Key("titleField"),
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              focusNode: _titleFocus,
              nextFocusNode: _amountFocus,
              initialValue: income.title,
              validator: Validator.notEmpty(),
              decoration: InputDecoration(labelText: "Title"),
              onSaved: (value) => income.title = value,
            ),
            MoniesTextFormField(
              context,
              key: Key("amountField"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              focusNode: _amountFocus,
              nextFocusNode: _dateFocus,
              controller: amountController,
              validator: Validator.amount(),
              decoration: InputDecoration(labelText: "Amount"),
              onSaved: (value) => income.amountExpression = value,
            ),
            DatePickerTextFormField(
              key: Key("dateField"),
              initialDate: income.date,
              dateFormatter: Format.date,
              focusNode: _dateFocus,
              validator: Validator.notEmpty(),
              decoration: InputDecoration(labelText: "Date"),
              onDatePicked: (date) => income.date = date,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> get dropdownItems {
    var types = {
      IncomeType.other: "Other",
      IncomeType.salary: "Salary",
      IncomeType.invoice: "Invoice",
      IncomeType.lastMonthBalance: "Last month's balance",
    };

    var items = types.keys.map((type) => DropdownMenuItem(child: Text(types[type]), value: type)).toList();
    return items;
  }
}
