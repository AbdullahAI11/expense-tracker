# Expense Tracker

A full-stack mobile application for recording and managing personal expenses.

The project demonstrates a complete flow from a Flutter mobile client to an ASP.NET Core Web API, through ADO.NET, with persistent storage in SQL Server.

## Features

- View expenses stored in SQL Server.
- Create new expenses with validation.
- Delete expenses with a 4-second Undo option.
- Restore expenses locally if deletion fails.
- Prevent duplicate submissions while creating an expense.
- Sort expenses by newest date, then expense ID.
- Display spending by category.
- Support light and dark themes.
- Handle loading, error, empty, and retry states.

## Tech Stack

| Layer | Technology |
| --- | --- |
| Mobile | Flutter, Dart |
| Backend | C#, ASP.NET Core Web API, .NET 8 |
| Data Access | ADO.NET, Microsoft.Data.SqlClient |
| Database | SQL Server |

## Architecture

```text
Flutter Mobile App
        ↓
    HTTP / JSON
        ↓
ASP.NET Core Web API
        ↓
  Business Layer
        ↓
Data Access Layer
        ↓
      ADO.NET
        ↓
    SQL Server
```

The Flutter application uses a lightweight feature-first structure.

The backend separates HTTP handling, business validation, and database access into small dedicated projects. ADO.NET is used intentionally instead of an ORM such as EF Core.

## API

| Method | Endpoint | Description |
| --- | --- | --- |
| `GET` | `/api/Expenses` | Get all expenses |
| `POST` | `/api/Expenses` | Create an expense |
| `DELETE` | `/api/Expenses/{expenseId}` | Delete an expense |

Example:

```json
{
  "title": "Lunch",
  "amount": 24.50,
  "expenseDate": "2026-08-29",
  "categoryCode": "food"
}
```

Supported categories:

- `food`
- `travel`
- `leisure`
- `work`

## Database

The project uses a single `dbo.Expenses` table:

| Column | Type |
| --- | --- |
| `ExpenseId` | `INT IDENTITY` |
| `Title` | `NVARCHAR(50)` |
| `Amount` | `DECIMAL(19,2)` |
| `ExpenseDate` | `DATE` |
| `CategoryCode` | `VARCHAR(10)` |

The database also enforces valid titles, positive amounts, and supported category codes.

Schema:

```text
database/001_initial_schema.sql
```

## Project Structure

```text
expense-tracker/
├── mobile/
├── backend/ExpenseTracker/
│   ├── ExpenseTracker.Api/
│   ├── ExpenseTracker.Business/
│   ├── ExpenseTracker.DataAccess/
│   └── ExpenseTracker.Shared/
└── database/
```

## Running Locally

### Database

Run:

```text
database/001_initial_schema.sql
```

against a local SQL Server instance.

### Backend

Configure the connection string using .NET User Secrets:

```bash
dotnet user-secrets set "ConnectionStrings:ExpenseTracker" "Server=localhost;Database=ExpenseTracker;Integrated Security=True;TrustServerCertificate=True;" --project backend/ExpenseTracker/ExpenseTracker.Api/ExpenseTracker.Api.csproj
```

Run the API:

```bash
dotnet run --project backend/ExpenseTracker/ExpenseTracker.Api/ExpenseTracker.Api.csproj --launch-profile http
```

### Flutter

From the `mobile/` directory:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5063
```

`10.0.2.2` allows an Android emulator to access the host computer.

## Validation

```bash
flutter analyze
flutter test
dotnet build backend/ExpenseTracker/ExpenseTracker.sln
```

## Scope

This project intentionally keeps its scope small and the architecture lightweight.

Currently:

- Currency is Saudi Riyal (`SAR`).
- Categories are fixed.
- Authentication is not implemented.
- Expense editing is not implemented.
- ADO.NET is used instead of EF Core.