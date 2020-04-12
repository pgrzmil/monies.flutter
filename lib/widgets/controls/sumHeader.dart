import 'package:flutter/material.dart';

class SumHeader extends StatelessWidget {
  final String sumText;

  const SumHeader({Key key, this.sumText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      child: Container(
        alignment: Alignment(1, 0),
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(sumText, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
