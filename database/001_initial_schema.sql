USE master;
GO

CREATE DATABASE ExpenseTracker;
GO

USE ExpenseTracker;
GO

CREATE TABLE dbo.Expenses
(
    ExpenseId INT IDENTITY(1,1) NOT NULL,
    Title NVARCHAR(50) NOT NULL,
    Amount DECIMAL(19,2) NOT NULL,
    ExpenseDate DATE NOT NULL,
    CategoryCode VARCHAR(10) NOT NULL,

    CONSTRAINT PK_Expenses
        PRIMARY KEY (ExpenseId),

    CONSTRAINT CK_Expenses_Title_NotBlank
        CHECK (LEN(LTRIM(RTRIM(Title))) > 0),

    CONSTRAINT CK_Expenses_Amount_Positive
        CHECK (Amount > 0),

    CONSTRAINT CK_Expenses_CategoryCode_Allowed
        CHECK (
            CategoryCode IN (
                'food',
                'travel',
                'leisure',
                'work'
            )
        )
);
GO