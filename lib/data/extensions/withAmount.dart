abstract class WithAmount {
  double amount;
}

extension WithAmountExtensions<T extends WithAmount> on Iterable<T> {
  double sum() {
    return fold(0, (value, expense) => value + expense.amount);
  }
}