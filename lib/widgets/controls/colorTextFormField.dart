import 'package:flutter/material.dart';
import 'package:monies/widgets/controls/dialogs.dart';

typedef void ColorPickingCallback(Color pickedDate);

class ColorPickerTextFormField extends StatefulWidget {
  final Color initialColor;
  final ColorPickingCallback onColorPicked;
  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<Color> onSaved;

  const ColorPickerTextFormField({Key key, this.initialColor, this.onColorPicked, this.decoration, this.validator, this.onSaved}) : super(key: key);

  @override
  _ColorPickerTextFormFieldState createState() => _ColorPickerTextFormFieldState();
}

class _ColorPickerTextFormFieldState extends State<ColorPickerTextFormField> {
  final colorTextController = TextEditingController();
  Color color;

  @override
  void initState() {
    super.initState();
    color = widget.initialColor;
    colorTextController.text = color.value?.toRadixString(16) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("colorField"),
      controller: colorTextController,
      validator: widget.validator,
      readOnly: true,
      decoration: widget.decoration,
      onSaved: (value) => widget.onSaved(color),
      onTap: () async {
        final selectedColor = await Dialogs.colorPicker(context, initialColor: color);
        colorTextController.text = selectedColor.value.toRadixString(16);
        setState(() => color = selectedColor);
        widget.onColorPicked(color);
      },
    );
  }
}
