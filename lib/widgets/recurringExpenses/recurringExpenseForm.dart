import 'package:flutter/material.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/moniesForm.dart';
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
    return MoniesForm(
      formKey: formKey,
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
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: _amountFocus,
            nextFocusNode: _dateFocus,
            initialValue: recurringExpense.amount != 0 ? recurringExpense.amount.toString() : "",
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
    );
  }
}
