import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/formSheetContent.dart';
import 'package:monies/widgets/incomes/incomesEmptyState.dart';
import 'package:provider/provider.dart';
import '../../data/extensions/withAmount.dart';

import 'incomesForm.dart';
import 'incomesListItem.dart';

class IncomesList extends StatelessWidget {
  final DateTime selectedDate;

  const IncomesList({Key key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final slidableController = SlidableController();
    return Consumer<IncomesProvider>(
      builder: (context, incomesProvider, child) {
        final incomes = incomesProvider.getForMonth(selectedDate.month, selectedDate.year);
        return Scaffold(
          appBar: AppBar(title: Text("Incomes (${Format.monthAndYear(selectedDate)})")),
          body: Column(children: [
            Container(
              alignment: Alignment(1, 0),
              color: Colors.grey.shade100,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(sumText(incomes), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            ),
            if (incomes.isEmpty) IncomesEmptyState(key: Key("incomesList_empty_state")),
            ListView.separated(
                shrinkWrap: true,
                itemCount: incomes.length,
                separatorBuilder: (context, index) => Divider(height: 0),
                itemBuilder: (context, index) {
                  final income = incomes.elementAt(index);
                  return Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.25,
                    controller: slidableController,
                    child: IncomesListItem(
                      income: income,
                      onTap: () => _showEditSheet(context, income, onSave: (income) => incomesProvider.edit(income)),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Remove',
                        color: Colors.redAccent,
                        icon: Icons.delete,
                        onTap: () async {
                          if (await Dialogs.confirmation(context, text: "Do you want to remove income?")) {
                            await incomesProvider.remove(income);
                          }
                        },
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.greenAccent,
                        icon: Icons.edit,
                        onTap: () => _showEditSheet(context, income, onSave: (income) => incomesProvider.edit(income)),
                      ),
                    ],
                  );
                })
          ]),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showEditSheet(context, Income.empty(), onSave: (income) => incomesProvider.add(income)),
          ),
        );
      },
    );
  }

  void _showEditSheet(BuildContext context, Income income, {Function(Income income) onSave}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FormSheetContent(
          formBuilder: (formKey) => IncomesForm(formKey: formKey, income: income),
          onSave: () => onSave(income),
        );
      },
    );
  }

  String sumText(Iterable<Income> incomes) {
    return incomes.isEmpty ? "" : "Σ ${Format.money(incomes.sum())}";
  }
}
