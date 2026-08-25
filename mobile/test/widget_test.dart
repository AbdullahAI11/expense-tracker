import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/app/app.dart';

void main() {
  testWidgets('displays Expense Tracker home screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    expect(find.text('Expense Tracker'), findsOneWidget);
  });
}
