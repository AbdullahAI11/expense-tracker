import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/core/network/api_config.dart';
import 'package:expense_tracker/features/expenses/models/expense.dart';
import 'package:expense_tracker/features/expenses/screens/add_expense_screen.dart';
import 'package:expense_tracker/features/expenses/state/expenses_controller.dart';
import 'package:expense_tracker/features/expenses/widgets/home_screen/expense_list.dart';
import 'package:expense_tracker/features/expenses/widgets/home_screen/spending_chart.dart';
import 'package:expense_tracker/features/expenses/data/api/expense_api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    _expensesController.loadExpenses();
  }

  final _expensesController = ExpensesController(
    const ExpenseApiService(
      baseUrl: ApiConfig.apiBaseUrl,
    ),
  );
  @override
  void dispose() {
    _expensesController.dispose();
    super.dispose();
  }

  Future<void> _addExpense() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => AddExpenseScreen(
          expensesController: _expensesController,
        ),
      ),
    );
  }

  Future<void> _deleteExpense(Expense expense, int index) async {
    final removedExpense = _expensesController.removeExpenseAt(index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF17004A),
        content: const Text(
          'Expense deleted',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        duration: const Duration(seconds: 4),
        persist: false,
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFDDC8FA),
          onPressed: () {
            _expensesController.insertExpense(index, removedExpense);
          },
        ),
      ),
    );

    final closeReason = await snackBarController.closed;

    if (closeReason == SnackBarClosedReason.action) {
      return;
    }

    final expenseId = removedExpense.expenseId;
    if (expenseId != null && expenseId > 0) {
      try {
        await _expensesController.deleteExpense(expenseId);
        return;
      } catch (_) {
        // Restore the local state below when the backend deletion fails.
      }
    }

    _expensesController.insertExpense(index, removedExpense);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : const Color(0xFF17004A),
        content: const Text(
          'Failed to delete expense. It was restored.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundAppBarColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFF17004A);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundAppBarColor,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _expensesController,
            builder: (context, child) {
              final canAddExpense =
                  !_expensesController.isLoading &&
                  _expensesController.loadErrorMessage == null;

              return IconButton(
                onPressed: canAddExpense ? _addExpense : null,
                icon: Icon(
                  Icons.add,
                  color: canAddExpense ? Colors.white : Colors.white38,
                  size: 28,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: ListenableBuilder(
          listenable: _expensesController,
          builder: (context, child) {
            if (_expensesController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final loadErrorMessage = _expensesController.loadErrorMessage;
            if (loadErrorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loadErrorMessage,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _expensesController.loadExpenses,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final expenses = _expensesController.expenses;

            return Column(
              children: [
                SpendingChart(expenses: expenses),
                const SizedBox(height: 30),
                Expanded(
                  child: expenses.isEmpty
                      ? Center(
                          child: Text(
                            'No expenses yet',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )
                      : ExpenseList(
                          expenses: expenses,
                          onDismissed: _deleteExpense,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
