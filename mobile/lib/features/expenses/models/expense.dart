class Expense {
  const Expense({
    this.expenseId,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final int? expenseId;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
}
