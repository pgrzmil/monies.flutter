import 'package:flutter/material.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/moniesForm.dart';
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
    return MoniesForm(
      key: formKey,
      child: Column(children: [
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
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          focusNode: _amountFocus,
          nextFocusNode: _dateFocus,
          initialValue: income.amount != 0 ? income.amount.toString() : "",
          decoration: InputDecoration(labelText: "Amount"),
          onSaved: (value) => income.amount = double.tryParse(value.replaceAll(RegExp(r','), ".")),
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
