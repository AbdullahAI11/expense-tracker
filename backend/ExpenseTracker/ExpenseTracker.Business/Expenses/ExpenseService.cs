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
}