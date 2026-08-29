using ExpenseTracker.DataAccess.Database;
using ExpenseTracker.DataAccess.Expenses;
using ExpenseTracker.Business.Expenses;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

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

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}


app.UseAuthorization();

app.MapControllers();

app.Run();