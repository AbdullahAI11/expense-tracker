import 'package:flutter/foundation.dart';

import 'package:expense_tracker/features/expenses/data/api/expense_api_service.dart';
import 'package:expense_tracker/features/expenses/data/requests/create_expense_request.dart';
import 'package:expense_tracker/features/expenses/models/expense.dart';

class ExpensesController extends ChangeNotifier {
  ExpensesController(this._expenseApiService);

  final ExpenseApiService _expenseApiService;

  final List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _loadErrorMessage;

  List<Expense> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  String? get loadErrorMessage => _loadErrorMessage;

  Future<void> loadExpenses() async {
    _isLoading = true;
    _loadErrorMessage = null;
    notifyListeners();

    try {
      final responses = await _expenseApiService.getAllExpenses();

      _expenses
        ..clear()
        ..addAll(
          responses.map((response) => response.toExpense()),
        );
    } catch (_) {
      _loadErrorMessage = 'Unable to load expenses. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createExpense({
    required String title,
    required double amount,
    required DateTime expenseDate,
    required String categoryCode,
  }) async {
    final response = await _expenseApiService.createExpense(
      CreateExpenseRequest(
        title: title,
        amount: amount,
        expenseDate: expenseDate,
        categoryCode: categoryCode,
      ),
    );

    addExpense(response.toExpense());
  }

  Future<void> deleteExpense(int expenseId) async {
    await _expenseApiService.deleteExpense(expenseId);
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _sortExpenses();
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
    _sortExpenses();
    notifyListeners();
  }

  void _sortExpenses() {
    _expenses.sort((first, second) {
      final dateComparison = second.date.compareTo(first.date);
      if (dateComparison != 0) {
        return dateComparison;
      }

      return (second.expenseId ?? -1).compareTo(first.expenseId ?? -1);
    });
  }
}
