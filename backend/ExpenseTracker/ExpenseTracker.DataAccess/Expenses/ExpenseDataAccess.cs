using ExpenseTracker.DataAccess.Database;
using ExpenseTracker.Shared.Models;
using Microsoft.Data.SqlClient;

namespace ExpenseTracker.DataAccess.Expenses;

public sealed class ExpenseDataAccess
{
    private readonly SqlConnectionFactory _connectionFactory;

    public ExpenseDataAccess(SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<List<Expense>> GetAllExpensesAsync()
    {
        const string query = """
            SELECT
                ExpenseId,
                Title,
                Amount,
                ExpenseDate,
                CategoryCode
            FROM dbo.Expenses
            ORDER BY ExpenseDate DESC, ExpenseId DESC;
            """;

        var expenses = new List<Expense>();

        await using SqlConnection connection =
            _connectionFactory.CreateConnection();

        await connection.OpenAsync();

        await using SqlCommand command =
            new SqlCommand(query, connection);

        await using SqlDataReader reader =
            await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            expenses.Add(
                new Expense
                {
                    ExpenseId = reader.GetInt32(0),
                    Title = reader.GetString(1),
                    Amount = reader.GetDecimal(2),
                    ExpenseDate = DateOnly.FromDateTime(reader.GetDateTime(3)),
                    CategoryCode = reader.GetString(4),
                }
            );
        }

        return expenses;
    }
}