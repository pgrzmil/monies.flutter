import 'package:flutter/material.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/expressionKeyboard.dart';
import 'package:monies/widgets/controls/moniesForm.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class RecurringExpenseForm extends StatelessWidget {
  final RecurringExpense recurringExpense;
  final GlobalKey<FormState> formKey;

  RecurringExpenseForm({Key key, this.formKey, this.recurringExpense}) : super(key: key) {
    amountController.text = recurringExpense.amountExpression;
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
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
            MoniesTextFormField(
              context,
              key: Key("titleField"),
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
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
              textCapitalization: TextCapitalization.sentences,
              focusNode: _locationFocus,
              nextFocusNode: _amountFocus,
              initialValue: recurringExpense.location,
              decoration: InputDecoration(labelText: "Location"),
              onSaved: (value) => recurringExpense.location = value,
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
              onSaved: (value) => recurringExpense.amountExpression = value,
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
      ),
    );
  }
}
