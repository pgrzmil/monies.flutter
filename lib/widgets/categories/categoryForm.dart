import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/utils/icons.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';
import 'package:monies/widgets/controls/colorTextFormField.dart';
import 'package:monies/widgets/controls/moniesTextFormField.dart';

class CategoryForm extends StatefulWidget {
  final ExpenseCategory category;
  final GlobalKey<FormState> formKey;

  const CategoryForm({Key key, this.formKey, this.category}) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  IconData icon;
  Color color;

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _iconFocus = FocusNode();
  final FocusNode _orderFocus = FocusNode();
  final FocusNode _colorFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    icon = widget.category.icon;
    color = widget.category.color;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(children: [
        Row(children: [
          CategoryIcon(icon: icon, color: color, radius: 50, iconSize: 60),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  MoniesTextFormField(
                    context,
                    key: Key("iconField"),
                    initialValue: widget.category.iconString,
                    validator: Validator.notEmpty(),
                    autocorrect: false,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    focusNode: _iconFocus,
                    nextFocusNode: _colorFocus,
                    decoration: InputDecoration(labelText: "Icon code"),
                    onChanged: (value) {
                      IconData iconData = IconsHelper.tryParse(value);
                      if (iconData != null) {
                        setState(() {
                          icon = iconData;
                        });
                      }
                    },
                    onSaved: (value) => widget.category.iconCode = IconsHelper.iconCodeFromName(value),
                  ),
                  ColorPickerTextFormField(
                    key: Key("colorField"),
                    initialColor: widget.category.color,
                    validator: Validator.notEmpty(),
                    focusNode: _colorFocus,
                    nextFocusNode: _titleFocus,
                    decoration: InputDecoration(labelText: "Color code"),
                    onColorPicked: (selectedColor) => setState(() => color = selectedColor),
                    onSaved: (color) => widget.category.colorCode = color.value,
                  ),
                ],
              ),
            ),
          ),
        ]),
        MoniesTextFormField(
          context,
          key: Key("titleField"),
          textInputAction: TextInputAction.next,
          focusNode: _titleFocus,
          nextFocusNode: _orderFocus,
          initialValue: widget.category.title,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Title"),
          onSaved: (value) => widget.category.title = value,
        ),
        MoniesTextFormField(
          context,
          key: Key("orderField"),
          initialValue: widget.category.order.toString(),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          focusNode: _orderFocus,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Order"),
          onSaved: (value) => widget.category.order = int.tryParse(value),
        ),
      ]),
    );
  }
}
