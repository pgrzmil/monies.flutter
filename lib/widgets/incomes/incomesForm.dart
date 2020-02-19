import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';

class IncomesForm extends StatelessWidget {
  final Income income;
  final GlobalKey<FormState> formKey;

  const IncomesForm({Key key, this.formKey, this.income}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //MoneyMaskedTextController could be working better. In case of too much free time can be fixed this in the future.
    final moneyFormatController =
        MoneyMaskedTextController(initialValue: income.amount, rightSymbol: " zł", decimalSeparator: ",", thousandSeparator: " ");
    return Form(
      key: formKey,
      child: Column(children: [
        TextFormField(
          key: Key("titleField"),
          initialValue: income.title,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Title"),
          onSaved: (value) => income.title = value,
        ),
        TextFormField(
          key: Key("amountField"),
          decoration: InputDecoration(labelText: "Amount"),
          keyboardType: TextInputType.number,
          controller: moneyFormatController,
          onSaved: (value) => income.amount = moneyFormatController.numberValue ?? 0,
        ),
        DatePickerTextFormField(
          key: Key("dateField"),
          initialDate: income.date,
          dateFormatter: Format.date,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Date"),
          onDatePicked: (date) => income.date = date,
        ),
      ]),
    );
  }
}
