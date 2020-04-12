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

  List<Series<CategoryWithSum, String>> get categoriesChartData {
    final data = sumByCategory;
    if (data.isEmpty || data.every((item) => item.sum == 0)) {
      return [
        Series<CategoryWithSum, String>(
          id: "EmptyChart",
          domainFn: (_, __) => "",
          measureFn: (CategoryWithSum item, _) => item.sum,
          data: [CategoryWithSum(null, 1)],
          colorFn: (_, __) => Color(a: 18, r: 0, g: 0, b: 0),
        ),
      ];
    }
    return [
      Series<CategoryWithSum, String>(
        id: 'sumByCategoryChart',
        domainFn: (CategoryWithSum item, _) => item.category.title,
        measureFn: (CategoryWithSum item, _) => item.sum,
        colorFn: (CategoryWithSum item, _) =>
            Color(a: item.category.color.alpha, r: item.category.color.red, g: item.category.color.green, b: item.category.color.blue),
        labelAccessorFn: (CategoryWithSum item, _) => item.sum != 0 ? item.category.title : "",
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
