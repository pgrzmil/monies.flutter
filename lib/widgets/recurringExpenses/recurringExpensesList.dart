import 'package:flutter/material.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/emptyState.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/controls/sumHeader.dart';
import 'package:monies/widgets/recurringExpenses/recurringExpenseAdd.dart';
import 'package:monies/widgets/recurringExpenses/recurringExpenseEdit.dart';
import 'package:monies/widgets/recurringExpenses/recurringExpensesListItem.dart';
import 'package:provider/provider.dart';
import '../../data/extensions/withAmount.dart';

class RecurringExpensesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecurringExpensesProvider>(
      builder: (context, recurringExpensesProvider, child) {
        final incomes = recurringExpensesProvider.getAll();
        return ItemsList<RecurringExpense>(
          items: incomes,
          title: "Recurring expenses".toUpperCase(),
          header: SumHeader(sumText: incomes.sumText()),
          emptyState: EmptyState(text: "Empty!\nStart adding recurring expenses.", key: Key("recurringExpensesList_empty_state")),
          onAdd: () => navigateToAdd(context),
          onEdit: (recurringExpense) => navigateToEdit(context, recurringExpense),
          onCellTap: (recurringExpense) => navigateToEdit(context, recurringExpense),
          onRefresh: recurringExpensesProvider.refresh,
          onRemove: (recurringExpense) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove recurring expense?")) {
              await recurringExpensesProvider.remove(recurringExpense);
            }
          },
          onCellCreate: (recurringExpense) => RecurringExpensesListItem(recurringExpense: recurringExpense),
        );
      },
    );
  }


  navigateToEdit(BuildContext context, RecurringExpense recurringExpense) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecurringExpenseEditView(recurringExpense: recurringExpense)));
  }

  navigateToAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RecurringExpenseAddView()));
  }
}
