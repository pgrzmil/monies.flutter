import 'package:flutter/material.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/services/signInService.dart';
import 'package:provider/provider.dart';
import 'incomeForm.dart';

class IncomeAddView extends StatefulWidget {
  final DateTime currentDate;

  const IncomeAddView({Key key, this.currentDate}) : super(key: key);

  @override
  _IncomeAddViewState createState() => _IncomeAddViewState(formKey: GlobalKey<FormState>());
}

class _IncomeAddViewState extends State<IncomeAddView> {
  final GlobalKey<FormState> formKey;

  _IncomeAddViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<SignInService>(context, listen: false).userId;
    final Income income = Income.empty(userId);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Add income".toUpperCase()),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: IncomeForm(
          income: income,
          formKey: formKey,
          currentDate: widget.currentDate,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<IncomesProvider>(context, listen: false).add(income);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
