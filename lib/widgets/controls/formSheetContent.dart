import 'package:flutter/material.dart';

typedef Widget FormBuilder(GlobalKey<FormState> formKey);

class FormSheetContent extends StatelessWidget {
  final FormBuilder formBuilder;
  final Function onSave;

  const FormSheetContent({Key key, this.formBuilder, this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
        return Padding(
          padding: EdgeInsets.all(10),
          child: Wrap(
            children: [
              formBuilder(formKey),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        onSave();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
  }
}