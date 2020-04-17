import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class MathExpressionKeyboard extends StatelessWidget {
  final FocusNode targetFocusNode;
  final TextEditingController targetTextController;
  final Widget child;

  const MathExpressionKeyboard({Key key, this.targetFocusNode, this.targetTextController, this.child}) : super(key: key);

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
                        onTap: () => targetTextController.text += char,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(char, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      );
                }).toList();
              }(),
            ),
          ],
        ),
        child: child);
  }
}
