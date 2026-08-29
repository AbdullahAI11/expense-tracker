import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:expense_tracker/features/expenses/data/responses/expense_response.dart';

class ExpenseApiService {
  const ExpenseApiService({
    required this.baseUrl,
  });

  final String baseUrl;

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
}
