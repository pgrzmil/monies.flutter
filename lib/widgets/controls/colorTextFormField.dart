import 'package:flutter/material.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

typedef void ColorPickingCallback(Color pickedDate);

class ColorPickerTextFormField extends StatefulWidget {
  final Color initialColor;
  final ColorPickingCallback onColorPicked;
  final InputDecoration decoration;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<Color> onSaved;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  const ColorPickerTextFormField({
    Key key,
    this.initialColor,
    this.focusNode,
    this.nextFocusNode,
    this.onColorPicked,
    this.decoration,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  _ColorPickerTextFormFieldState createState() => _ColorPickerTextFormFieldState();
  
}

class _ColorPickerTextFormFieldState extends State<ColorPickerTextFormField> {
  final colorTextController = TextEditingController();
  Color color;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    color = widget.initialColor;
    colorTextController.text = color.value?.toRadixString(16) ?? "";
    widget.focusNode?.addListener(() => _openPicker(context));
  }

  @override
  Widget build(BuildContext context) {
    return MoniesTextFormField(
      context,
      key: Key("colorField"),
      controller: colorTextController,
      validator: widget.validator,
      readOnly: true,
      decoration: widget.decoration,
      textInputAction: TextInputAction.next,
      focusNode: widget.focusNode,
      nextFocusNode: widget.nextFocusNode,
      onSaved: (value) => widget.onSaved(color),
      onTap: () => _openPicker(context),
    );
  }

  Future _openPicker(BuildContext context) async {
    //prevents from opening picker when focus is changing on navigation change`
    if (isOpen || !widget.focusNode.hasFocus) return;

    isOpen = true;
    final selectedColor = await Dialogs.colorPicker(context, initialColor: color);
    isOpen = false;

    colorTextController.text = selectedColor.value.toRadixString(16);
    setState(() => color = selectedColor);

    widget.focusNode.unfocus();
    FocusScope.of(context).requestFocus(widget.nextFocusNode);

    widget.onColorPicked(color);
  }
}
