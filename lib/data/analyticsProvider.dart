import 'package:charts_common/src/data/series.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:monies/data/models/category.dart';
import 'package:monies/utils/formatters.dart';
import 'categoriesProvider.dart';
import 'extensions/withAmount.dart';
import 'expensesProvider.dart';

class AnalyticsProvider extends ChangeNotifier {
  ExpensesProvider _expensesProvider;
  CategoriesProvider _categoriesProvider;

  DateTime _currentDate = DateTime.now();

  String get title => "Analyze (${Format.monthAndYear(_currentDate)})";

  List<CategoryWithSum> get sumByCategory {
    List<CategoryWithSum> result = List<CategoryWithSum>();

    for (var category in _categoriesProvider.getAll()) {
      final sum = _expensesProvider.getForMonth(_currentDate.month, _currentDate.year).filterByCategory(category.id).sum();
      result.add(CategoryWithSum(category, sum));
    }

    return result;
  }

  AnalyticsProvider setProviders({ExpensesProvider expensesProvider, CategoriesProvider categoriesProvider}) {
    _categoriesProvider = categoriesProvider;
    _expensesProvider = expensesProvider;
    notifyListeners();
    return this;
  }

  List<Series> get categoriesChartData {
    final data = sumByCategory;
    return [
      Series<CategoryWithSum, String>(
        id: 'sumByCategoryChart',
        domainFn: (CategoryWithSum sales, _) => sales.category.title,
        measureFn: (CategoryWithSum sales, _) => sales.sum,
        colorFn: (CategoryWithSum sales, _) =>
            Color(a: sales.category.color.alpha, r: sales.category.color.red, g: sales.category.color.green, b: sales.category.color.blue),
        labelAccessorFn: (CategoryWithSum sales, _) => sales.sum != 0 ? sales.category.title : "",
        outsideLabelStyleAccessorFn: (CategoryWithSum sales, _) => TextStyleSpec(color: Color.black, fontSize: 12),
        data: data,
      )
    ];
  }

  void switchToNextMonth() {
    _currentDate = Jiffy(_currentDate).add(months: 1);
    notifyListeners();
  }

  void switchToPreviousMonth() {
    _currentDate = Jiffy(_currentDate).subtract(months: 1);
    notifyListeners();
  }

  DateTime get currentDate => _currentDate;

  void setCurrentDate(DateTime currentDate) {
    _currentDate = currentDate;
    notifyListeners();
  }
}

class CategoryWithSum {
  final ExpenseCategory category;
  final double sum;

  CategoryWithSum(this.category, this.sum);
}
