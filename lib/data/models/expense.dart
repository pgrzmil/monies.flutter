class Expense {
  final String id;
  final String title;
  final String location;
  final double amount;

  String get amountString {
    return '$amount zł';
  }

  Expense(this.id, this.title, this.location, this.amount);

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(json['id'] as String, 
                   json['title'] as String,
                   json['location'] as String,
                   json['amount'] as double);
  }
}