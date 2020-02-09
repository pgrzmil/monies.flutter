import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

abstract class Format {
  static String date(DateTime date, {Locale locale}) {
    return date != null ? DateFormat('dd/MM/yyyy').format(date) : "";
  }

  static String monthAndYear(DateTime date, {Locale locale}) {
    return DateFormat.MMMM().add_y().format(date);
  }

  static String money(double amount, {Locale locale}) {
    return "${amount.toStringAsFixed(2)} zł";
  }
}

abstract class Validator {
  static FormFieldValidator<String> notEmpty([String message = "Enter value"]) {
    return (value) => value.isEmpty ? value : null;
  }

  static FormFieldValidator notNull([String message = "Select value"]) {
    return (value) => value == null ? message : null;
  }
}
