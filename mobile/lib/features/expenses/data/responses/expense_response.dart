import 'package:expense_tracker/features/expenses/models/expense.dart';

class ExpenseResponse {
  const ExpenseResponse({
    required this.expenseId,
    required this.title,
    required this.amount,
    required this.expenseDate,
    required this.categoryCode,
  });

  final int expenseId;
  final String title;
  final double amount;
  final DateTime expenseDate;
  final String categoryCode;

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      expenseId: json['expenseId'] as int,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expenseDate'] as String),
      categoryCode: json['categoryCode'] as String,
    );
  }

  Expense toExpense() {
    return Expense(
      expenseId: expenseId,
      title: title,
      amount: amount,
      date: expenseDate,
      category: categoryCode,
    );
  }
}
