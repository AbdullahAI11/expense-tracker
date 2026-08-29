using ExpenseTracker.Business.Expenses;
using ExpenseTracker.Shared.Models;
using Microsoft.AspNetCore.Mvc;
using ExpenseTracker.Api.Contracts.Requests;

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

    [HttpPost]
    public async Task<ActionResult<Expense>> CreateExpense(
    CreateExpenseRequest request
)
    {
        try
        {
            var expense = await _expenseService.CreateExpenseAsync(
                request.Title,
                request.Amount,
                request.ExpenseDate,
                request.CategoryCode
            );

            return StatusCode(
                StatusCodes.Status201Created,
                expense
            );
        }
        catch (ArgumentException exception)
        {
            return BadRequest(
                new
                {
                    message = exception.Message
                }
            );
        }
    }
    [HttpDelete("{expenseId:int}")]
    public async Task<IActionResult> DeleteExpense(int expenseId)
    {
        try
        {
            var deleted =
                await _expenseService.DeleteExpenseAsync(expenseId);

            if (!deleted)
            {
                return NotFound(
                    new
                    {
                        message = "Expense was not found."
                    }
                );
            }

            return NoContent();
        }
        catch (ArgumentException exception)
        {
            return BadRequest(
                new
                {
                    message = exception.Message
                }
            );
        }
    }
}