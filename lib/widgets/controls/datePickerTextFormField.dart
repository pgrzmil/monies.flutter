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

  const DatePickerTextFormField({Key key, this.initialDate, this.onDatePicked, this.decoration, this.validator, this.dateFormatter})
      : super(key: key);

  @override
  _DatePickerTextFormFieldState createState() => _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  final dateTextController = TextEditingController();
  DateTime pickedDate;

  @override
  void initState() {
    dateTextController.text = widget.dateFormatter(widget.initialDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateTextController,
      validator: widget.validator,
      readOnly: true,
      decoration: widget.decoration,
      onTap: () => _selectDate(context),
      onSaved: (value) {
        if (pickedDate != null && widget.onDatePicked != null) {
          widget.onDatePicked(pickedDate);
        }
      },
    );
  }

  _selectDate(BuildContext context) async {
    final date = await showDatePicker(context: context, initialDate: widget.initialDate, firstDate: DateTime(1901), lastDate: DateTime(2101));
    if (date != null) {
      setState(() {
        pickedDate = date;
        dateTextController.text = widget.dateFormatter(date);
      });
    }
  }
}
