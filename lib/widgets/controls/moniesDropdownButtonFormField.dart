import 'package:flutter/material.dart';

class MoniesDropdownButtonFormField<T> extends StatefulWidget {
  final T initialValue;
  final List<DropdownMenuItem<T>> items;
  final DropdownButtonBuilder selectedItemBuilder;
  final Widget hint;
  final ValueChanged<T> onChanged;
  final InputDecoration decoration;
  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final bool autovalidate = false;

  const MoniesDropdownButtonFormField({
    Key key,
    this.items,
    this.selectedItemBuilder,
    this.hint,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.decoration,
  }) : super(key: key);

  @override
  _MoniesDropdownButtonFormFieldState<T> createState() => _MoniesDropdownButtonFormFieldState<T>();
}

class _MoniesDropdownButtonFormFieldState<T> extends State<MoniesDropdownButtonFormField<T>> {
  T _value;

@override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      hint: widget.hint,
      value: _value,
      onChanged: (val) {
        setState(() {
          _value = val;
        });
        widget.onChanged(val);
      },
      items: widget.items,
      validator: widget.validator,
      decoration: widget.decoration,
      onSaved: widget.onSaved,
      autovalidate: widget.autovalidate,
      selectedItemBuilder: widget.selectedItemBuilder,
    );
  }
}
