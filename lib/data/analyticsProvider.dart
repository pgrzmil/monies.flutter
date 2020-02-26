import 'package:charts_common/src/data/series.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:monies/data/models/category.dart';
import 'categoriesProvider.dart';
import 'extensions/withAmount.dart';
import 'expensesProvider.dart';

class AnalyticsProvider extends ChangeNotifier {
  ExpensesProvider _expensesProvider;
  CategoriesProvider _categoriesProvider;

  List<CategoryWithSum> sumByCategory(int month, int year) {
    List<CategoryWithSum> result = List<CategoryWithSum>();

    for (var category in _categoriesProvider.getAll()) {
      final sum = _expensesProvider.getForMonth(month, year).filterByCategory(category.id).sum();
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

  List<Series> categoriesChartData(int month, int year) {
    final data = sumByCategory(month, year);
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
}

class CategoryWithSum {
  final ExpenseCategory category;
  final double sum;

  CategoryWithSum(this.category, this.sum);
}
