import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryPickerFormField.dart';
import 'package:monies/widgets/controls/datePickerTextFormField.dart';
import 'package:monies/widgets/controls/expressionKeyboard.dart';
import 'package:monies/widgets/controls/moniesForm.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class ExpenseForm extends StatefulWidget {
  final Expense expense;
  final GlobalKey<FormState> formKey;
  final DateTime currentDate;

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final amountController = TextEditingController();

  ExpenseForm({
    this.expense,
    this.formKey,
    this.currentDate,
  }) {
    titleController.text = expense.title;
    locationController.text = expense.location;
    amountController.text = expense.amountExpression;
  }

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  TextInputType amountKeyboard = TextInputType.numberWithOptions(decimal: true);

  @override
  void initState() {
    super.initState();
    if (widget.amountController.text.contains("#")) {
      amountKeyboard = TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MoniesForm(
      formKey: widget.formKey,
      child: MathExpressionKeyboard(
        targetFocusNode: _amountFocus,
        targetTextController: widget.amountController,
        keyboardChangeRequested: (keyboard) async {
          //changes keyboard to text when adding comment
          if (keyboard != amountKeyboard) {
            final selection = widget.amountController.selection;

            FocusScope.of(context).unfocus();
            setState(() => amountKeyboard = keyboard);

            Future.delayed(const Duration(milliseconds: 100), () {
              FocusScope.of(context).requestFocus(_amountFocus);
              widget.amountController.selection = selection;
            });
          }
        },
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
              controller: widget.titleController,
              validator: Validator.notEmpty(),
              decoration: InputDecoration(labelText: "Title"),
              onSaved: (value) => widget.expense.title = value,
            ),
            MoniesTextFormField(
              context,
              key: Key("locationField"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              focusNode: _locationFocus,
              nextFocusNode: _amountFocus,
              controller: widget.locationController,
              decoration: InputDecoration(labelText: "Location"),
              onSaved: (value) => widget.expense.location = value,
            ),
            MoniesTextFormField(
              context,
              key: Key("amountField"),
              keyboardType: amountKeyboard,
              textInputAction: TextInputAction.next,
              focusNode: _amountFocus,
              nextFocusNode: _dateFocus,
              decoration: InputDecoration(labelText: "Amount"),
              controller: widget.amountController,
              validator: Validator.amount(),
              onSaved: (value) => widget.expense.amountExpression = value,
              onChanged: (value) async {},
            ),
            DatePickerTextFormField(
              key: Key("dateField"),
              initialDate: widget.currentDate ?? widget.expense.date,
              dateFormatter: Format.date,
              focusNode: _dateFocus,
              validator: Validator.notEmpty(),
              decoration: InputDecoration(labelText: "Date"),
              onDatePicked: (date) => widget.expense.date = date,
            ),
            CategoryPickerFormField(
              key: Key("categoryDropDown"),
              initialCategoryId: widget.expense.categoryId,
              decoration: InputDecoration(labelText: "Category"),
              validator: Validator.notNull("Pick category"),
              onCategoryPicked: (category) => widget.expense.categoryId = category.id,
            ),
          ],
        ),
      ),
    );
  }
}
