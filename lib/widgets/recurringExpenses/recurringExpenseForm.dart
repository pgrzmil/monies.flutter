import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class RecurringExpenseForm extends StatelessWidget {
  final RecurringExpense recurringExpense;
  final GlobalKey<FormState> formKey;

  RecurringExpenseForm({Key key, this.formKey, this.recurringExpense}) : super(key: key);

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController =
        MoneyMaskedTextController(initialValue: recurringExpense.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");
    return Form(
      key: formKey,
      child: Column(
        children: [
          MoniesTextFormField(
            context,
            key: Key("titleField"),
            autofocus: true,
            textInputAction: TextInputAction.next,
            focusNode: _titleFocus,
            nextFocusNode: _locationFocus,
            initialValue: recurringExpense.title,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Title"),
            onSaved: (value) => recurringExpense.title = value,
          ),
          MoniesTextFormField(
            context,
            key: Key("locationField"),
            textInputAction: TextInputAction.next,
            focusNode: _locationFocus,
            nextFocusNode: _amountFocus,
            initialValue: recurringExpense.location,
            decoration: InputDecoration(labelText: "Location"),
            onSaved: (value) => recurringExpense.location = value,
          ),
          MoniesTextFormField(
            context,
            key: Key("amountField"),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: _amountFocus,
            nextFocusNode: _dateFocus,
            controller: moneyFormatController,
            decoration: InputDecoration(labelText: "Amount"),
            onSaved: (value) => recurringExpense.amount = moneyFormatController.numberValue ?? 0,
          ),
          DatePickerTextFormField(
            key: Key("dateField"),
            initialDate: recurringExpense.startDate,
            dateFormatter: Format.date,
            focusNode: _dateFocus,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Start date"),
            onDatePicked: (date) => recurringExpense.startDate = date,
          ),
          CategoryPickerFormField(
            key: Key("categoryDropDown"),
            initialCategoryId: recurringExpense.categoryId,
            decoration: InputDecoration(labelText: "Category"),
            validator: Validator.notNull("Pick category"),
            onCategoryPicked: (category) => recurringExpense.categoryId = category.id,
          ),
        ],
      ),
    );
  }
}
