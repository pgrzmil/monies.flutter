import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:monies/widgets/controls/emptyState.dart';
import 'package:monies/widgets/controls/itemsList.dart';
import 'package:monies/widgets/recurringExpenses/recurringExpensesList.dart';
import 'package:provider/provider.dart';
import 'expenseAdd.dart';
import 'expenseEdit.dart';
import './expensesListItem.dart';
import '../../data/extensions/withAmount.dart';

enum _MenuItems {
  showRecurring,
  resetRecurring,
}

class ExpensesList extends StatefulWidget {
  final DateTime selectedDate;
  final String categoryFilter;

  const ExpensesList({
    Key key,
    this.selectedDate,
    this.categoryFilter,
  }) : super(key: key);

  @override
  _ExpensesListState createState() => _ExpensesListState(categoryFilter);
}

class _ExpensesListState extends State<ExpensesList> {
  final _filterAllValue = "All";

  String categoryFilter;

  _ExpensesListState(this.categoryFilter);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<SignInService>(context, listen: false).userId;
      Provider.of<ExpensesProvider>(context, listen: false).updateWithRecurring(widget.selectedDate.month, widget.selectedDate.year, userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        var expenses = expensesProvider.getForMonth(widget.selectedDate.month, widget.selectedDate.year).filterByCategory(categoryFilter).toList();
        //index of the item to which should be added footer with "planned expense" message. 
        //-1 because expression will return first in the future and message needs to be attached to the one before
        final firstFutureExpenseIndex = expenses.indexWhere((expense) => expense.date.compareTo(DateTime.now()) > 0) - 1;

        return ItemsList<Expense>(
          key: PageStorageKey("ExpensesListKey"),
          items: expenses,
          appBar: _appBar(expensesProvider),
          header: _header(expenses.sumText()),
          emptyState: EmptyState(text: "Empty!\nStart adding expenses.", key: Key("expensesList_empty_state")),
          onAdd: navigateToAdd,
          onEdit: (expense) => navigateToEdit(expense),
          onCellTap: (expense) => navigateToEdit(expense),
          onRefresh: expensesProvider.refresh,
          onRemove: (expense) async {
            if (await Dialogs.confirmation(context, text: "Do you want to remove expense?")) {
              await expensesProvider.remove(expense);
            }
          },
          onCellCreate: (expense, index) => ExpensesListItem(expense: expense),
          onCellFooterCreate: (_, index) {
            if (index == expenses.length - 1) {
              return SizedBox(height: 50);
            } else if (index == firstFutureExpenseIndex) {
              return Text("Planned expenses".toUpperCase());
            }
            return null;
          },
        );
      },
    );
  }

  navigateToEdit(Expense expense) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expense: expense)));
  }

  navigateToAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAddView(currentDate: widget.selectedDate)));
  }

  List<DropdownMenuItem> get dropdownItems {
    var categories = Provider.of<CategoriesProvider>(context, listen: false).getAll();

    var items = categories.map((category) => DropdownMenuItem(child: Text(category.title), value: category.id)).toList();
    items.insert(0, DropdownMenuItem(child: Text("All"), value: _filterAllValue));
    return items;
  }

  menuItemSelected(_MenuItems itemValue, ExpensesProvider expensesProvider) {
    switch (itemValue) {
      case _MenuItems.showRecurring:
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecurringExpensesList()));
        break;
      case _MenuItems.resetRecurring:
        final userId = Provider.of<SignInService>(context, listen: false).userId;
        expensesProvider.resetAllRecurring(widget.selectedDate.month, widget.selectedDate.year, userId);
        break;
      default:
    }
  }

  AppBar _appBar(ExpensesProvider expensesProvider) {
    return AppBar(
      title: Text("Expenses (${Format.monthAndYear(widget.selectedDate)})".toUpperCase()),
      actions: <Widget>[
        PopupMenuButton(
          color: Theme.of(context).backgroundColor,
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
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          DropdownButton(
            hint: Text("Filter by category", style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.title.color)),
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
