import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:expense_tracker/features/expenses/data/requests/create_expense_request.dart';
import 'package:expense_tracker/features/expenses/data/responses/expense_response.dart';

class ExpenseApiService {
  const ExpenseApiService({
    required this.baseUrl,
  });

  final String baseUrl;

  Future<ExpenseResponse> createExpense(
    CreateExpenseRequest request,
  ) async {
    final uri = Uri.parse('$baseUrl/api/Expenses');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create expense. Status code: ${response.statusCode}',
      );
    }

    return ExpenseResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<ExpenseResponse>> getAllExpenses() async {
    final uri = Uri.parse('$baseUrl/api/Expenses');

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load expenses. Status code: ${response.statusCode}',
      );
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList
        .map(
          (json) => ExpenseResponse.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> deleteExpense(int expenseId) async {
    final uri = Uri.parse('$baseUrl/api/Expenses/$expenseId');

    final response = await http.delete(uri);

    if (response.statusCode != 204) {
      throw Exception(
        'Failed to delete expense. Status code: ${response.statusCode}',
      );
    }
  }
}
