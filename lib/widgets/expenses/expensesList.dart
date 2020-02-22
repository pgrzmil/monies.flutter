import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/dialogs.dart';
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

        return Scaffold(
          appBar: AppBar(
            title: Text("Expenses (${Format.monthAndYear(widget.selectedDate)})"),
            actions: <Widget>[
              PopupMenuButton(
                onSelected: (_) => expensesProvider.refreshRecurring(widget.selectedDate.month, widget.selectedDate.year),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text("Reset recurring expenses"),
                      value: "ResetRecurring",
                    )
                  ];
                },
              )
            ],
          ),
          body: Column(
            children: [
              Container(
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
                      Text(sumText(expenses)),
                    ],
                  )),
              if (expenses.isEmpty) ExpensesEmptyState(key: Key("expensesList_empty_state")),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: expenses.length,
                  separatorBuilder: (context, index) => Divider(height: 0),
                  itemBuilder: (context, index) {
                    final slidableController = SlidableController();
                    final expense = expenses.elementAt(index);
                    return Slidable(
                      actionPane: SlidableBehindActionPane(),
                      actionExtentRatio: 0.25,
                      controller: slidableController,
                      child: InkWell(
                        onTap: () => navigateToEdit(expense),
                        child: ExpensesListItem(expense),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Remove',
                          color: Colors.redAccent,
                          icon: Icons.delete,
                          onTap: () async {
                            if (await Dialogs.confirmation(context, text: "Do you want to remove expense?")) {
                              await expensesProvider.remove(expense);
                            }
                          },
                        ),
                      ],
                    );
                  }),
            ],
          ),
          floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: navigateToAdd),
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

  String sumText(Iterable<Expense> expenses) {
    return expenses.isEmpty ? "" : "Σ ${Format.money(expenses.sum())}";
  }

  List<DropdownMenuItem> get dropdownItems {
    var categories = Provider.of<CategoriesProvider>(context, listen: false).getAll();

    var items = categories.map((category) => DropdownMenuItem(child: Text(category.title), value: category.id)).toList();
    items.insert(0, DropdownMenuItem(child: Text("All"), value: _filterAllValue));
    return items;
  }
}
