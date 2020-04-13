abstract class WithDate {
  DateTime date;
}

extension WithDateExtensions<T extends WithDate> on Iterable<T> {
  Iterable<T> filterByDate(int month, int year) {
    return this.where((expense) => expense.date.month == month && expense.date.year == year);
  }

  List<T> sortByDateAsc() {
    var sorted = this.toList();
    sorted.sort((exp1, exp2) => exp1.date.compareTo(exp2.date));
    return sorted;
  }

 List<T> sortByDateDesc() {
    var sorted = this.toList();
    sorted.sort((exp1, exp2) => exp2.date.compareTo(exp1.date));
    return sorted;
  }
}