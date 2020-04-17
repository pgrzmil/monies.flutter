import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:monies/utils/mathParser.dart';

abstract class Format {
  static String date(DateTime date, {Locale locale}) {
    return date != null ? DateFormat('dd/MM/yyyy').format(date) : "";
  }

  static String monthAndYear(DateTime date, {Locale locale}) {
    return DateFormat.MMMM().add_y().format(date);
  }

  static String money(double amount, {Locale locale}) {
    return "${amount.toStringAsFixed(2)} zł".replaceAll(".", ",");
  }
}

abstract class Validator {
  static FormFieldValidator<String> notEmpty([String message = "Enter value"]) {
    return (value) => value.isEmpty ? value : null;
  }

  static FormFieldValidator notNull([String message = "Select value"]) {
    return (value) => value == null ? message : null;
  }

  static FormFieldValidator<String> amount([String message = "Incorrect expression format"]) {
    return (value) {
      if (value == null || value.isEmpty) {
        return "Enter value";
      } else {
        try {
          MathExpressionParser.parseValue(value);
        } catch (e) {
          return message;
        }
      }
      return null;
    };
  }
}
