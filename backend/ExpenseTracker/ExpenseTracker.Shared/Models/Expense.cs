namespace ExpenseTracker.Shared.Models;

public sealed class Expense
{
    public int ExpenseId { get; set; }

    public string Title { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public DateOnly ExpenseDate { get; set; }

    public string CategoryCode { get; set; } = string.Empty;
}