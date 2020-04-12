import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String expenses;
  final String incomes;
  final GestureTapCallback onIncomesTap;

  const BalanceCard({Key key, this.balance, this.expenses, this.incomes, this.onIncomesTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w700);
    return Card(
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(balance, style: TextStyle(fontSize: 36)),
            Text("Balance".toUpperCase(), style: subtitleStyle),
            Text(expenses, style: TextStyle(fontSize: 26)),
            Text("Expenses sum".toUpperCase(), style: subtitleStyle),
            InkWell(
              child: Column(
                children: [
                  Text(incomes, style: TextStyle(fontSize: 26)),
                  Text("Incomes sum".toUpperCase(), style: subtitleStyle),
                ],
              ),
              onTap: onIncomesTap,
            )
          ],
        ),
      ),
    );
  }
}
