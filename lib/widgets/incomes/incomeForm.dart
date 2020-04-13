import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class IncomeForm extends StatelessWidget {
  final Income income;
  final GlobalKey<FormState> formKey;

  IncomeForm({Key key, this.formKey, this.income}) : super(key: key);

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController =
        MoneyMaskedTextController(initialValue: income.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");

    return Form(
      key: formKey,
      child: Column(children: [
        MoniesTextFormField(
          context,
          key: Key("titleField"),
          autofocus: true,
          textInputAction: TextInputAction.next,
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
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          focusNode: _amountFocus,
          nextFocusNode: _dateFocus,
          controller: moneyFormatController,
          decoration: InputDecoration(labelText: "Amount"),
          onSaved: (value) => income.amount = moneyFormatController.numberValue ?? 0,
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
      ]),
    );
  }
}
