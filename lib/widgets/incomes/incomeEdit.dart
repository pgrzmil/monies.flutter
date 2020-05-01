import 'package:flutter/material.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:provider/provider.dart';
import 'incomeForm.dart';

class IncomeEditView extends StatefulWidget {
  final Income income;
  final DateTime currentDate;

  IncomeEditView({this.income, this.currentDate});

  @override
  _IncomeEditViewState createState() => _IncomeEditViewState(formKey: GlobalKey<FormState>());
}

class _IncomeEditViewState extends State<IncomeEditView> {
  final GlobalKey<FormState> formKey;

  _IncomeEditViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.income.title.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to remove income?")) {
                await Provider.of<IncomesProvider>(context, listen: false).remove(widget.income);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: IncomeForm(
          income: widget.income,
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
            Provider.of<IncomesProvider>(context, listen: false).edit(widget.income);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
