import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class ExpenseForm extends StatelessWidget {
  final Expense expense;
  final GlobalKey<FormState> formKey;

  ExpenseForm(this.expense, this.formKey) {
    titleController.text = expense.title;
    locationController.text = expense.location;
    amountController.text = expense.amount != 0 ? expense.amount.toString() : "";
  }

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          MoniesTextFormField(
            context,
            key: Key("titleField"),
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            focusNode: _titleFocus,
            nextFocusNode: _locationFocus,
            controller: titleController,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Title"),
            onSaved: (value) => expense.title = value,
          ),
          MoniesTextFormField(
            context,
            key: Key("locationField"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            focusNode: _locationFocus,
            nextFocusNode: _amountFocus,
            controller: locationController,
            decoration: InputDecoration(labelText: "Location"),
            onSaved: (value) => expense.location = value,
          ),
          MoniesTextFormField(
            context,
            key: Key("amountField"),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: _amountFocus,
            nextFocusNode: _dateFocus,
            decoration: InputDecoration(labelText: "Amount"),
            controller: amountController,
            onSaved: (value) => expense.amount = double.tryParse(value.replaceAll(RegExp(r','), ".")) ?? 0,
          ),
          DatePickerTextFormField(
            key: Key("dateField"),
            initialDate: expense.date,
            dateFormatter: Format.date,
            focusNode: _dateFocus,
            validator: Validator.notEmpty(),
            decoration: InputDecoration(labelText: "Date"),
            onDatePicked: (date) => expense.date = date,
          ),
          CategoryPickerFormField(
            key: Key("categoryDropDown"),
            initialCategoryId: expense.categoryId,
            decoration: InputDecoration(labelText: "Category"),
            validator: Validator.notNull("Pick category"),
            onCategoryPicked: (category) => expense.categoryId = category.id,
          ),
        ],
      ),
    );
  }
}
