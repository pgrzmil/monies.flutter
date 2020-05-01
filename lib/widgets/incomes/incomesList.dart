import 'package:flutter/material.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/models/income.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/emptyState.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/controls/sumHeader.dart';
import 'package:provider/provider.dart';
import '../../data/extensions/withAmount.dart';
import 'incomeAdd.dart';
import 'incomeEdit.dart';
import 'incomesListItem.dart';

class IncomesList extends StatelessWidget {
  final DateTime selectedDate;

  const IncomesList({Key key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomesProvider>(
      builder: (context, incomesProvider, child) {
        final incomes = incomesProvider.getForMonth(selectedDate.month, selectedDate.year).toList();
        return ItemsList<Income>(
          key: PageStorageKey("IncomesListKey"),
          items: incomes,
          title: "Incomes (${Format.monthAndYear(selectedDate)})".toUpperCase(),
          header: SumHeader(sumText: incomes.sumText()),
          emptyState: EmptyState(text: "Empty!\nStart adding incomes.", key: Key("incomesList_empty_state")),
          onAdd: () => navigateToAdd(context),
          onEdit: (income) => navigateToEdit(context, income),
          onCellTap: (income) => navigateToEdit(context, income),
          onRefresh: incomesProvider.refresh,
          onRemove: (income) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove income?")) {
              await incomesProvider.remove(income);
            }
          },
          onCellCreate: (income, index) => IncomesListItem(income: income),
          onCellFooterCreate: (_, index) {
            if (index == incomes.length - 1) {
              return SizedBox(height: 50);
            }
            return null;
          },
        );
      },
    );
  }

  navigateToEdit(BuildContext context, Income income) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeEditView(income: income, currentDate: selectedDate)));
  }

  navigateToAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeAddView(currentDate: selectedDate)));
  }
}
