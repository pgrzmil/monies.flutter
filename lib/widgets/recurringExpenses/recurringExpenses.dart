import 'package:flutter/material.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/emptyState.dart';
import 'package:monies/widgets/controls/formSheetContent.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/controls/sumHeader.dart';
import 'package:monies/widgets/recurringExpenses/recurringExpensesForm.dart';
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
          title: "Recurring expenses",
          header: SumHeader(sumText: incomes.sumText()),
          emptyState: EmptyState(text: "Empty!\nStart adding recurring expenses.", key: Key("recurringExpensesList_empty_state")),
          onAdd: () => _showEditSheet(context, RecurringExpense.empty(), onSave: (recurringExpense) => recurringExpensesProvider.add(recurringExpense)),
          onEdit: (recurringExpense) => _showEditSheet(context, recurringExpense, onSave: (recurringExpense) => recurringExpensesProvider.edit(recurringExpense)),
          onCellTap: (recurringExpense) => _showEditSheet(context, recurringExpense, onSave: (recurringExpense) => recurringExpensesProvider.edit(recurringExpense)),
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

  void _showEditSheet(BuildContext context, RecurringExpense recurringExpense, {Function(RecurringExpense recurringExpense) onSave}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FormSheetContent(
          formBuilder: (formKey) => RecurringExpensesForm(formKey: formKey, recurringExpense: recurringExpense),
          onSave: () => onSave(recurringExpense),
        );
      },
    );
  }
}
