import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/utils/formatters.dart';
import 'package:provider/provider.dart';

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
          appBar: AppBar(
            title: Text("Incomes (${Format.monthAndYear(selectedDate)})"),
          ),
          body: ListView.separated(
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
                    onTap: () => "", //_settingModalBottomSheet(context, income, (category) => incomesProvider.edit(category)),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Remove',
                      color: Colors.redAccent,
                      icon: Icons.delete,
                      // onTap: () async {
                      //   if (await _showConfirmationDialog(context)) {
                      //     await incomesProvider.remove(category);
                      //   }
                      // },
                    ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.greenAccent,
                      icon: Icons.edit,
                      // onTap: () => _settingModalBottomSheet(context, category, (category) => incomesProvider.edit(category)),
                    ),
                  ],
                );
              }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => "", // _settingModalBottomSheet(context, ExpenseCategory.empty(), (category) => incomesProvider.add(category)),
          ),
        );
      },
    );
  }
}
