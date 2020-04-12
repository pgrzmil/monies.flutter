import 'package:flutter/widgets.dart';

class DismissKeyboard extends GestureDetector {
  DismissKeyboard(BuildContext context, {Key key, Widget child})
      : super(
            key: key,
            child: child,
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            });
}
