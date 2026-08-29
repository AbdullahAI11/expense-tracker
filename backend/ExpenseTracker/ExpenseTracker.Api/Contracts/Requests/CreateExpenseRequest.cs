namespace ExpenseTracker.Api.Contracts.Requests;

public sealed class CreateExpenseRequest
{
    public string Title { get; set; } = string.Empty;

    public decimal Amount { get; set; }

    public DateOnly ExpenseDate { get; set; }

    public string CategoryCode { get; set; } = string.Empty;
}
