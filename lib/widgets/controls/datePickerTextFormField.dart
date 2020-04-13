import 'package:flutter/material.dart';
import 'package:intl/locale.dart';

typedef void DatePickingCallback(DateTime pickedDate);
typedef String DateFormatter(DateTime date, {Locale locale});

class DatePickerTextFormField extends StatefulWidget {
  final DateTime initialDate;
  final DatePickingCallback onDatePicked;
  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final DateFormatter dateFormatter;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextEditingController dateTextController = TextEditingController();

  DatePickerTextFormField({
    Key key,
    this.initialDate,
    this.onDatePicked,
    this.decoration,
    this.validator,
    this.dateFormatter,
    this.focusNode,
    this.nextFocusNode,
  }) : super(key: key) {
    this.dateTextController.text = dateFormatter(initialDate);
  }

  @override
  _DatePickerTextFormFieldState createState() => _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime pickedDate;
  bool isOpen = false;
  VoidCallback onFocused;

  @override
  void initState() {
    super.initState();
    onFocused = () => _selectDate(context);
    widget.focusNode?.addListener(onFocused);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.dateTextController,
      validator: widget.validator,
      readOnly: true,
      decoration: widget.decoration,
      focusNode: widget.focusNode,
      onTap: () => _selectDate(context),
      onSaved: (value) {
        if (pickedDate != null && widget.onDatePicked != null) {
          widget.onDatePicked(pickedDate);
        }
      },
    );
  }

  _selectDate(BuildContext context) async {
    //prevents from opening picker when focus is changing on navigation change`
    if (isOpen) return;

    widget.focusNode?.removeListener(onFocused);
    isOpen = true;
    final date = await showDatePicker(context: context, initialDate: widget.initialDate, firstDate: DateTime(2001), lastDate: DateTime(2101));
    isOpen = false;

    if (date != null) {
      setState(() {
        pickedDate = date;
        widget.dateTextController.text = widget.dateFormatter(date);
      });

      widget.focusNode.unfocus();
      FocusScope.of(context).requestFocus(widget.nextFocusNode);
    }
  }
}
