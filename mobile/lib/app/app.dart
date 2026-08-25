import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/screens/home_screen.dart';

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
