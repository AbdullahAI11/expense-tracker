import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/features/expenses/screens/add_expense_screen.dart';

import 'package:expense_tracker/features/expenses/widgets/spending_chart.dart';

import 'package:expense_tracker/features/expenses/widgets/expense_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            SpendingChart(),
            SizedBox(height: 30),
            Expanded(
              child: ExpenseList(
                expenses: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
