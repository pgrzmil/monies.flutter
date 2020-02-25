import 'package:flutter/material.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/formSheetContent.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/controls/sumHeader.dart';
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
    return Consumer<IncomesProvider>(
      builder: (context, incomesProvider, child) {
        final incomes = incomesProvider.getForMonth(selectedDate.month, selectedDate.year);
        return ItemsList<Income>(
          items: incomes,
          title: "Incomes (${Format.monthAndYear(selectedDate)})",
          header: SumHeader(sumText: incomes.sumText()),
          emptyState: IncomesEmptyState(key: Key("incomesList_empty_state")),
          onAdd: () => _showEditSheet(context, Income.empty(), onSave: (income) => incomesProvider.add(income)),
          onEdit: (income) => _showEditSheet(context, income, onSave: (income) => incomesProvider.edit(income)),
          onCellTap: (income) => _showEditSheet(context, income, onSave: (income) => incomesProvider.edit(income)),
          onRemove: (income) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove income?")) {
              await incomesProvider.remove(income);
            }
          },
          onCellCreate: (income) => IncomesListItem(income: income),
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
}
