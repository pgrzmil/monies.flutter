import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoniesTextFormField extends TextFormField {
  final FocusNode nextFocusNode;

  MoniesTextFormField(
    BuildContext context, {
    Key key,
    TextEditingController controller,
    String initialValue,
    FocusNode focusNode,
    this.nextFocusNode,
    InputDecoration decoration,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    TextStyle style,
    bool autofocus = false,
    bool readOnly = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool autovalidate = false,
    int maxLength,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    ValueChanged<String> onFieldSubmitted,
  }) : super(
          key: key,
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          decoration: decoration,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: style,
          autofocus: autofocus,
          readOnly: readOnly,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          autovalidate: autovalidate,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onTap: onTap,
          onSaved: onSaved,
          validator: validator,
          inputFormatters: inputFormatters,
          
          onFieldSubmitted: onFieldSubmitted ?? (term) => _fieldFocusChange(context, focusNode, nextFocusNode),
        );

  static _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
