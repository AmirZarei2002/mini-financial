# Class Diagram سیستم مدیریت مالی شخصی

```mermaid
classDiagram
    class User {
        +int userId PK
        +str fullName
        +str email
        +str password
        +str currency
        +datetime createdAt
        +register()
        +login()
        +logout()
        +updateProfile()
    }
    class Account {
        +int id PK
        +int userId FK
        +str name
        +enum type
        +decimal initialBalance
        +bool isActive
        +datetime createdAt
        +create() void
        +update() void
        +delete() void
        +getCurrentBalance() decimal
    }
    class Category {
        +int id PK
        +int userId FK
        +varchar name
        +enum type
        +str color
        +datetime createdAt
        +create() void
        +update() void
        +delete() void
    }
    class Transaction {
        +int id PK
        +int userId FK
        +int accountId FK
        +int categoryId FK
        +decimal amount
        +enum type
        +text description
        +date date
        +datetime createdAt
        +create() void
        +update() void
        +delete() void
        +getDetails()
    }
    class Transfer {
        +int id PK
        +int userId FK
        +int fromAccountId FK
        +int toAccountId FK
        +decimal amount
        +date date
        +text description
        +create() void
        +delete() void
    }
    class Tag {
        +int id PK
        +int userId FK
        +str name
        +create() void
        +delete() void
    }
    class Budget {
        +int id PK
        +int userId FK
        +int categoryId FK
        +decimal amount
        +date periodStart
        +date periodEnd
        +create() void
        +update() void
        +getSpent() decimal
        +getRemaining() decimal
        +isOverBudget() bool
    }
    class RecurringTransaction {
        +int id PK
        +int userId FK
        +int accountId FK
        +int categoryId FK
        +decimal amount
        +enum type
        +enum frequency
        +date startOn
        +date endOn
        +date nextRunOn
        +bool isActive
        +run() Transaction
        +pause() void
    }
    class SavingsGoal {
        +int id PK
        +int userId FK
        +str name
        +decimal targetAmount
        +decimal savedAmount
        +date deadline
        +bool isAchieved
        +addSaving(amount) void
        +getProgress() decimal
    }
    class Report {
        +int userId FK
        +date startDate
        +date endDate
        +generate()
        +getTotalIncome() decimal
        +getTotalExpense() decimal
        +getByCategory()
    }

    User "1" --> "*" Account : has
    User "1" --> "*" Category : owns
    User "1" --> "*" Transaction : records
    User "1" --> "*" Transfer : makes
    User "1" --> "*" Tag : owns
    User "1" --> "*" Budget : sets
    User "1" --> "*" RecurringTransaction : defines
    User "1" --> "*" SavingsGoal : has
    User "1" --> "*" Report : requests
    Account "1" --> "*" Transaction : contains
    Account "1" --> "*" Transfer : source / destination
    Category "1" --> "*" Transaction : classifies
    Category "1" --> "*" Budget : limits
    RecurringTransaction "1" ..> "*" Transaction : creates
    Transaction "*" -- "*" Tag : tagged with
    Report "1" ..> "*" Transaction : uses
```

## توضیح کلاس‌ها

| کلاس | مسئولیت |
|---|---|
| User | ثبت‌نام، ورود، خروج و ویرایش پروفایل |
| Account | نگهداری حساب‌ها و محاسبه موجودی فعلی |
| Category | دسته‌بندی درآمد و هزینه |
| Transaction | ثبت، ویرایش، حذف و نمایش جزئیات تراکنش |
| Transfer | جابه‌جایی پول بین دو حساب |
| Tag | برچسب‌گذاری تراکنش‌ها |
| Budget | تعیین سقف هزینه برای هر دسته و بررسی عبور از آن |
| RecurringTransaction | ساخت خودکار تراکنش‌های تکراری |
| SavingsGoal | پیگیری هدف پس‌انداز |
| Report | ساخت گزارش در یک بازه زمانی از روی تراکنش‌ها |
