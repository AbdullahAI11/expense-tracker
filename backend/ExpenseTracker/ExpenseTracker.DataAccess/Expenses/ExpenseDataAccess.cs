using ExpenseTracker.DataAccess.Database;
using ExpenseTracker.Shared.Models;
using Microsoft.Data.SqlClient;
using System.Data;

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

    public async Task<Expense> CreateExpenseAsync(
    string title,
    decimal amount,
    DateOnly expenseDate,
    string categoryCode
)
    {
        const string query = """
        INSERT INTO dbo.Expenses
        (
            Title,
            Amount,
            ExpenseDate,
            CategoryCode
        )
        OUTPUT INSERTED.ExpenseId
        VALUES
        (
            @Title,
            @Amount,
            @ExpenseDate,
            @CategoryCode
        );
        """;

        await using SqlConnection connection =
            _connectionFactory.CreateConnection();

        await connection.OpenAsync();

        await using SqlCommand command =
            new SqlCommand(query, connection);

        command.Parameters.Add(
            "@Title",
            SqlDbType.NVarChar,
            50
        ).Value = title;

        var amountParameter =
            command.Parameters.Add(
                "@Amount",
                SqlDbType.Decimal
            );

        amountParameter.Precision = 19;
        amountParameter.Scale = 2;
        amountParameter.Value = amount;

        command.Parameters.Add(
            "@ExpenseDate",
            SqlDbType.Date
        ).Value = expenseDate.ToDateTime(TimeOnly.MinValue);

        command.Parameters.Add(
            "@CategoryCode",
            SqlDbType.VarChar,
            10
        ).Value = categoryCode;

        var result = await command.ExecuteScalarAsync();

        if (result is null || result == DBNull.Value)
        {
            throw new InvalidOperationException(
                "Failed to create the expense."
            );
        }

        var expenseId = Convert.ToInt32(result);

        return new Expense
        {
            ExpenseId = expenseId,
            Title = title,
            Amount = amount,
            ExpenseDate = expenseDate,
            CategoryCode = categoryCode,
        };
    }

    public async Task<bool> DeleteExpenseAsync(int expenseId)
    {
        const string query = """
        DELETE FROM dbo.Expenses
        WHERE ExpenseId = @ExpenseId;
        """;

        await using SqlConnection connection =
            _connectionFactory.CreateConnection();

        await connection.OpenAsync();

        await using SqlCommand command =
            new SqlCommand(query, connection);

        command.Parameters.Add(
            "@ExpenseId",
            SqlDbType.Int
        ).Value = expenseId;

        var affectedRows = await command.ExecuteNonQueryAsync();

        return affectedRows > 0;
    }
}