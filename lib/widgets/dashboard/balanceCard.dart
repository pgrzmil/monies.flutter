import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final String balance;
  final String expenses;
  final String incomes;
  final GestureTapCallback onIncomesTap;

  const BalanceCard({Key key, this.balance, this.expenses, this.incomes, this.onIncomesTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(balance, style: TextStyle(fontSize: 36)),
            Text("Balance", style: TextStyle(fontSize: 10)),
            Text(expenses, style: TextStyle(fontSize: 26)),
            Text("Expenses sum", style: TextStyle(fontSize: 10)),
            InkWell(
              child: Column(
                children: [
                  Text(incomes, style: TextStyle(fontSize: 26)),
                  Text("Incomes sum", style: TextStyle(fontSize: 10)),
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
