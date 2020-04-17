import 'package:monies/utils/formatters.dart';

abstract class WithAmount {
  String amountExpression;
  double get amount;
}

extension WithAmountExtensions<T extends WithAmount> on Iterable<T> {
  double sum() {
    return fold(0, (value, expense) => value + expense.amount);
  }

  String sumText() {
    return isEmpty ? "" : "Σ ${Format.money(sum())}";
  }
}
