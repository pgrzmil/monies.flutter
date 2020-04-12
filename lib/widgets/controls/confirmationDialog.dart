import 'package:flutter/material.dart';

class ConfirmationDialog extends AlertDialog {
  ConfirmationDialog({
    Key key,
    String text,
    String confirmButtonText,
    Color confirmButtonColor,
    BuildContext context,
  }) : super(
          key: key,
          title: Text(text),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(fontSize: 15)),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              key: Key("confirm_dialog_button_ok"),
              child: Text(confirmButtonText, style: TextStyle(color: confirmButtonColor, fontSize: 15)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
}
