import 'package:flutter/foundation.dart';

import 'package:expense_tracker/features/expenses/data/api/expense_api_service.dart';
import 'package:expense_tracker/features/expenses/models/expense.dart';

class ExpensesController extends ChangeNotifier {
  ExpensesController(this._expenseApiService);

  final ExpenseApiService _expenseApiService;

  final List<Expense> _expenses = [];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  Future<void> loadExpenses() async {
    final responses = await _expenseApiService.getAllExpenses();

    _expenses
      ..clear()
      ..addAll(
        responses.map((response) => response.toExpense()),
      );

    notifyListeners();
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  Expense removeExpenseAt(int index) {
    final expense = _expenses.removeAt(index);
    notifyListeners();
    return expense;
  }

  void insertExpense(int index, Expense expense) {
    final insertionIndex = index < 0
        ? 0
        : index > _expenses.length
        ? _expenses.length
        : index;

    _expenses.insert(insertionIndex, expense);
    notifyListeners();
  }
}
