import 'package:flutter/material.dart';
import 'package:monies/widgets/controls/colorPickerDialog.dart';
import 'package:monies/widgets/controls/confirmationDialog.dart';

class Dialogs {
  static Future<bool> confirmation(
    BuildContext context, {
    String text,
    String confirmButtonText = "REMOVE",
    Color confirmButtonColor = Colors.redAccent,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          ConfirmationDialog(context: context, text: text, confirmButtonColor: confirmButtonColor, confirmButtonText: confirmButtonText),
    );
    return result ?? false;
  }

  static Future<Color> colorPicker(BuildContext context, {Color initialColor}) async {
    var selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) => ColorPickerDialog(initialColor: initialColor),
    );
    return selectedColor ?? initialColor;
  }
}
