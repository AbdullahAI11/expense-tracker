using ExpenseTracker.DataAccess.Database;
using ExpenseTracker.DataAccess.Expenses;
using ExpenseTracker.Business.Expenses;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

var connectionString =
    builder.Configuration.GetConnectionString("ExpenseTracker")
    ?? throw new InvalidOperationException(
        "Connection string 'ExpenseTracker' was not found."
    );

builder.Services.AddSingleton(
    new SqlConnectionFactory(connectionString)
);

builder.Services.AddScoped<ExpenseDataAccess>();
builder.Services.AddScoped<ExpenseService>();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.Run();
