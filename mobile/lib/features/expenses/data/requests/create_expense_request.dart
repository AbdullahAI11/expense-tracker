class CreateExpenseRequest {
  const CreateExpenseRequest({
    required this.title,
    required this.amount,
    required this.expenseDate,
    required this.categoryCode,
  });

  final String title;
  final double amount;
  final DateTime expenseDate;
  final String categoryCode;

  Map<String, dynamic> toJson() {
    final year = expenseDate.year.toString().padLeft(4, '0');
    final month = expenseDate.month.toString().padLeft(2, '0');
    final day = expenseDate.day.toString().padLeft(2, '0');

    return {
      'title': title,
      'amount': amount,
      'expenseDate': '$year-$month-$day',
      'categoryCode': categoryCode,
    };
  }
}
