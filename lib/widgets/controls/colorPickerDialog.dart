import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const ColorPickerDialog({Key key, this.initialColor}) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color selectedColor;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pick a color"),
          content: MaterialColorPicker(
            shrinkWrap: true,
            selectedColor: widget.initialColor,
             onColorChange: (color) => selectedColor = color,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 15)),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("SELECT", style: TextStyle(color: Colors.black, fontSize: 15)),
               onPressed: () => Navigator.pop(context, selectedColor),
            ),
          ],
    );
  }
}