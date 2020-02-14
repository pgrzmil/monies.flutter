import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/expenses/expensesEmptyState.dart';
import 'package:provider/provider.dart';
import 'expenseAdd.dart';
import 'expenseEdit.dart';
import './expensesListItem.dart';

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
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        var expenses = expensesProvider.getForMonth(widget.selectedDate.month, widget.selectedDate.year).filterByCategory(categoryFilter).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text("Expenses (${Format.monthAndYear(widget.selectedDate)})"),
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
                    return InkWell(
                      onTap: () => navigateToEdit(expenses.elementAt(index)),
                      child: ExpensesListItem(expenses.elementAt(index)),
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
