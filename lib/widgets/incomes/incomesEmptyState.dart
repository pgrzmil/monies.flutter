import 'package:flutter/material.dart';

class IncomesEmptyState extends StatelessWidget {

  const IncomesEmptyState({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40),
      alignment: Alignment(0, 0),
      color: Colors.white,
      child: Text(
        "Empty!\nStart adding incomes.",
        style: TextStyle(fontSize: 20, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
