import 'package:flutter/material.dart';

class MoniesForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;
  final bool enableExitPopup;

  const MoniesForm({
    Key key,
    this.formKey,
    this.child,
    this.enableExitPopup = true,
  }) : super(key: key);

  @override
  _MoniesFormState createState() => _MoniesFormState();
}

class _MoniesFormState extends State<MoniesForm> {
  bool wasChanged = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: widget.child,
      onChanged: () => setState(() => wasChanged = true),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    bool result = true;

    if (widget.enableExitPopup && wasChanged) {
      result = await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Unsaved data will be lost.'),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'.toUpperCase()),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes, go back'.toUpperCase(), style: TextStyle(color: Theme.of(context).accentColor)),
            ),
          ],
        ),
      );
    }

    return result ?? false;
  }
}
