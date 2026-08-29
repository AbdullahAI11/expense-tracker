using ExpenseTracker.Business.Expenses;
using ExpenseTracker.Shared.Models;
using Microsoft.AspNetCore.Mvc;

namespace ExpenseTracker.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public sealed class ExpensesController : ControllerBase
{
    private readonly ExpenseService _expenseService;

    public ExpensesController(ExpenseService expenseService)
    {
        _expenseService = expenseService;
    }

    [HttpGet]
    public async Task<ActionResult<List<Expense>>> GetAllExpenses()
    {
        var expenses = await _expenseService.GetAllExpensesAsync();

        return Ok(expenses);
    }
}