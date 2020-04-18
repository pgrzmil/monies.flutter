import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class MathExpressionKeyboard extends StatelessWidget {
  final FocusNode targetFocusNode;
  final TextEditingController targetTextController;
  final Widget child;
  final Function(TextInputType newKeyboard) keyboardChangeRequested;

  MathExpressionKeyboard({Key key, this.targetFocusNode, this.targetTextController, this.child, this.keyboardChangeRequested}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
        config: KeyboardActionsConfig(
          keyboardBarColor: Colors.grey[700],
          nextFocus: false,
          actions: [
            KeyboardAction(
              focusNode: targetFocusNode,
              toolbarButtons: () {
                final chars = ["#", "(", ")", "/", "*", "-", "+", "="];
                return chars.map((char) {
                  return (node) => InkWell(
                        onTap: () => _insert(char),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(char, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
                        ),
                      );
                }).toList();
              }(),
            ),
          ],
        ),
        child: child);
  }

  _insert(String char) {
    final selection = targetTextController.selection;
    final text = targetTextController.text;

    if (char == "#") {
      char = "##";
    }

    String modifiedText = "${text.substring(0, selection.baseOffset)}$char${text.substring(selection.extentOffset)}";
    targetTextController.value = TextEditingValue(text: modifiedText, selection: TextSelection.collapsed(offset: selection.baseOffset + 1));

    if (char == "##") {
      keyboardChangeRequested(TextInputType.text);
    }
  }
}
