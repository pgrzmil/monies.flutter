import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categories/categoryIcon.dart';
import 'package:monies/widgets/controls/colorTextFormField.dart';

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
          CategoryIcon(icon: icon, color: color, radius: 50),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  ColorPickerTextFormField(
                    key: Key("colorField"),
                    initialColor: widget.category.color,
                    validator: Validator.notEmpty(),
                    decoration: InputDecoration(labelText: "Color code"),
                    onColorPicked: (selectedColor) => setState(() => color = selectedColor),
                    onSaved: (color) => widget.category.colorCode = color.value,
                  ),
                  TextFormField(
                    key: Key("iconField"),
                    initialValue: widget.category.iconCode?.toString(),
                    validator: Validator.notEmpty(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Icon code"),
                    maxLength: 6,
                    onChanged: (value) {
                      final code = int.tryParse(value);
                      if (code != null) {
                        final iconData = IconData(code, fontFamily: "MaterialIcons");
                        if (iconData != null) {
                          setState(() {
                            icon = iconData;
                          });
                        }
                      }
                    },
                    onSaved: (value) => widget.category.iconCode = int.tryParse(value),
                  ),
                ],
              ),
            ),
          ),
        ]),
        TextFormField(
          key: Key("titleField"),
          initialValue: widget.category.title,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Title"),
          onSaved: (value) => widget.category.title = value,
        ),
        TextFormField(
          key: Key("orderField"),
          initialValue: widget.category.order.toString(),
          keyboardType: TextInputType.number,
          validator: Validator.notEmpty(),
          decoration: InputDecoration(labelText: "Order"),
          onSaved: (value) => widget.category.order = int.tryParse(value),
        ),
      ]),
    );
  }
}
