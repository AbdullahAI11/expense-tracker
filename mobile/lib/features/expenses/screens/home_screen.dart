import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      baseUrl: 'http://10.0.2.2:5063',
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

  void _deleteExpense(Expense expense, int index) {
    final removedExpense = _expensesController.removeExpenseAt(index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
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
          IconButton(
            onPressed: _addExpense,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
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
