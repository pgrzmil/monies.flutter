import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;

  const EmptyState({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(top: 40, bottom: 40),
      alignment: Alignment(0, 0),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
