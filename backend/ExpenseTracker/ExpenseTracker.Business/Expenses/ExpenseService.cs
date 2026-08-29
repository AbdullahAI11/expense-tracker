using ExpenseTracker.DataAccess.Expenses;
using ExpenseTracker.Shared.Models;

namespace ExpenseTracker.Business.Expenses;

public sealed class ExpenseService
{
    private readonly ExpenseDataAccess _expenseDataAccess;

    public ExpenseService(ExpenseDataAccess expenseDataAccess)
    {
        _expenseDataAccess = expenseDataAccess;
    }

    public async Task<List<Expense>> GetAllExpensesAsync()
    {
        return await _expenseDataAccess.GetAllExpensesAsync();
    }

    public async Task<Expense> CreateExpenseAsync(
    string title,
    decimal amount,
    DateOnly expenseDate,
    string categoryCode
)
    {
        title = title.Trim();
        categoryCode = categoryCode.Trim().ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(title))
        {
            throw new ArgumentException(
                "Title is required."
            );
        }

        if (title.Length > 50)
        {
            throw new ArgumentException(
                "Title cannot exceed 50 characters."
            );
        }

        if (amount <= 0)
        {
            throw new ArgumentException(
                "Amount must be greater than zero."
            );
        }

        if (amount != decimal.Round(amount, 2))
        {
            throw new ArgumentException(
                "Amount cannot have more than 2 decimal places."
            );
        }

        var today = DateOnly.FromDateTime(DateTime.Today);

        if (expenseDate > today)
        {
            throw new ArgumentException(
                "Expense date cannot be in the future."
            );
        }

        string[] allowedCategories =
        [
            "food",
        "travel",
        "leisure",
        "work",
    ];

        if (!allowedCategories.Contains(categoryCode))
        {
            throw new ArgumentException(
                "Invalid expense category."
            );
        }

        return await _expenseDataAccess.CreateExpenseAsync(
            title,
            amount,
            expenseDate,
            categoryCode
        );
    }
}