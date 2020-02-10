import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/categoriesListItem.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final slidableController = SlidableController();
    return Consumer<CategoriesProvider>(
      builder: (context, categoriesProvider, child) {
        final categories = categoriesProvider.getAll();
        return Scaffold(
          appBar: AppBar(
            title: Text("Categories"),
          ),
          body: ListView.separated(
              padding: EdgeInsets.only(top: 10),
              itemCount: categories.length,
              separatorBuilder: (context, index) => Divider(height: 0),
              itemBuilder: (context, index) {
                final category = categories.elementAt(index);
                return Slidable(
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 0.25,
                  controller: slidableController,
                  child: CategoriesListItem(
                    category: category,
                    onTap: () => _settingModalBottomSheet(context, category, (category) => categoriesProvider.edit(category)),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Remove',
                      color: Colors.redAccent,
                      icon: Icons.delete,
                      onTap: () async {
                        if (await _showConfirmationDialog(context)) {
                          await categoriesProvider.remove(category);
                        }
                      },
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.greenAccent,
                      icon: Icons.edit,
                      onTap: () => _settingModalBottomSheet(context, category, (category) => categoriesProvider.edit(category)),
                    ),
                  ],
                );
              }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _settingModalBottomSheet(context, ExpenseCategory.empty(), (category) => categoriesProvider.add(category)),
          ),
        );
      },
    );
  }

  void _settingModalBottomSheet(BuildContext context, ExpenseCategory category, Function(ExpenseCategory category) onSave) {
    final colorTextController = TextEditingController(text: category.colorCode.toRadixString(16));

    showModalBottomSheet(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        return Padding(
            padding: EdgeInsets.all(10),
            child: Wrap(children: [
              Form(
                key: formKey,
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    CircleColor(
                      color: category.color,
                      circleSize: 50,
                      iconSelected: category.icon,
                      isSelected: true,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(children: <Widget>[
                          TextFormField(
                            onTap: () {
                              //temp solution before extracting component
                              var selectedColor = category.color;
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Pick a color"),
                                      content: MaterialColorPicker(
                                        shrinkWrap: true,
                                        selectedColor: selectedColor,
                                        onColorChange: (color) => selectedColor = color,
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 15)),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        FlatButton(
                                          child: Text("SELECT", style: TextStyle(color: Colors.black, fontSize: 15)),
                                          onPressed: () {
                                            colorTextController.text = selectedColor.value.toRadixString(16);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            key: Key("colorField"),
                            controller: colorTextController,
                            validator: Validator.notEmpty(),
                            readOnly: true,
                            decoration: InputDecoration(labelText: "Color code"),
                            onSaved: (value) => category.colorCode = int.tryParse(value, radix: 16),
                          ),
                          TextFormField(
                            key: Key("iconField"),
                            initialValue: category.iconCode.toString(),
                            validator: Validator.notEmpty(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Icon code"),
                            onSaved: (value) => category.iconCode = int.tryParse(value),
                          ),
                        ]),
                      ),
                    ),
                  ]),
                  TextFormField(
                    key: Key("titleField"),
                    initialValue: category.title,
                    validator: Validator.notEmpty(),
                    decoration: InputDecoration(labelText: "Title"),
                    onSaved: (value) => category.title = value,
                  ),
                  TextFormField(
                    key: Key("orderField"),
                    initialValue: category.order.toString(),
                    keyboardType: TextInputType.number,
                    validator: Validator.notEmpty(),
                    decoration: InputDecoration(labelText: "Order"),
                    onSaved: (value) => category.order = int.tryParse(value),
                  ),
                ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                FlatButton(
                  child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("SAVE", style: TextStyle(color: Colors.black, fontSize: 15)),
                  onPressed: () {
                    final form = formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      onSave(category);
                      Navigator.pop(context);
                    }
                  },
                ),
              ]),
            ]));
      },
    );
  }

  Future<bool> _showConfirmationDialog(context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Do you want to remove category"),
          actions: [
            FlatButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.black, fontSize: 15)),
              onPressed: () => Navigator.pop(context, false),
            ),
            FlatButton(
              child: Text("REMOVE", style: TextStyle(color: Colors.redAccent, fontSize: 15)),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
