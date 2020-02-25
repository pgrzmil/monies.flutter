import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/expenses/expensesEmptyState.dart';
import 'package:provider/provider.dart';
import 'expenseAdd.dart';
import 'expenseEdit.dart';
import './expensesListItem.dart';
import '../../data/extensions/withAmount.dart';

class ExpensesList extends StatefulWidget {
  final DateTime selectedDate;

  const ExpensesList({Key key, this.selectedDate}) : super(key: key);

  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  final _filterAllValue = "All";

  String categoryFilter;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => Provider.of<ExpensesProvider>(context, listen: false).updateWithRecurring(widget.selectedDate.month, widget.selectedDate.year));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        var expenses = expensesProvider.getForMonth(widget.selectedDate.month, widget.selectedDate.year).filterByCategory(categoryFilter).toList();

        return ItemsList<Expense>(
          items: expenses,
          appBar: _appBar(expensesProvider),
          header: _header(expenses.sumText()),
          emptyState: ExpensesEmptyState(key: Key("expensesList_empty_state")),
          onAdd: navigateToAdd,
          onEdit: (expense) => navigateToEdit(expense),
          onCellTap: (expense) => navigateToEdit(expense),
          onRemove: (expense) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove expense?")) {
              await expensesProvider.remove(expense);
            }
          },
          onCellCreate: (expense) => ExpensesListItem(expense: expense),
        );
      },
    );
  }

  navigateToEdit(Expense expense) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expense: expense)));
  }

  navigateToAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAddView()));
  }

  List<DropdownMenuItem> get dropdownItems {
    var categories = Provider.of<CategoriesProvider>(context, listen: false).getAll();

    var items = categories.map((category) => DropdownMenuItem(child: Text(category.title), value: category.id)).toList();
    items.insert(0, DropdownMenuItem(child: Text("All"), value: _filterAllValue));
    return items;
  }


  AppBar _appBar(ExpensesProvider expensesProvider) {
    return AppBar(
      title: Text("Expenses (${Format.monthAndYear(widget.selectedDate)})"),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (item) => menuItemSelected(item, expensesProvider),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("Reset recurring expenses"),
                value: _MenuItems.resetRecurring,
              ),
              PopupMenuItem(
                child: Text("Show recurring expenses"),
                value: _MenuItems.showRecurring,
              )
            ];
          },
        )
      ],
    );
  }

  Container _header(String sumText) {
    return Container(
      alignment: Alignment(0, 0),
      color: Colors.white,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          DropdownButton(
            hint: Text("Filter by category"),
            value: categoryFilter,
            onChanged: ((category) {
              setState(() {
                categoryFilter = category == _filterAllValue ? null : category;
              });
            }),
            items: dropdownItems,
          ),
          Spacer(),
          Text(sumText),
        ],
      ),
    );
  }
}
