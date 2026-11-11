# Activity Diagrams سیستم مدیریت مالی شخصی

## ۱. Login / Sign up

```mermaid
flowchart TD
    A((Start)) --> B[Form]
    B --> C[Login]
    B --> D[Create Account]
    C --> E{Control}
    E -- No --> F[Error] --> B
    E -- Yes --> G[Login] --> H((End))
    D --> I{Is information valid?}
    I -- No --> J[Error] --> B
    I -- Yes --> K[Create Account] --> L[Success] --> M((End))
```

## ۲. Add Expense (اضافه کردن هزینه)

```mermaid
flowchart TD
    A((Start)) --> B[Enter Expense Details]
    B --> C{Is Amount Valid?}
    C -- No --> D[Show Error Message] --> B
    C -- Yes --> E{Is Category Selected?}
    E -- No --> F[Select Category] --> E
    E -- Yes --> G[Save Expense]
    G --> H[Update Balance]
    H --> I{Over Budget?}
    I -- Yes --> J[Show Budget Alert] --> K((End))
    I -- No --> K
```

## ۳. View Balance (مشاهده موجودی)

```mermaid
flowchart TD
    A((Start)) --> B[Open Balance Page]
    B --> C{Are Transactions Available?}
    C -- No --> D[Display Zero Balance]
    C -- Yes --> E[Calculate Income and Expenses]
    E --> F[Display Current Balance]
    D --> G{View Details?}
    F --> G
    G -- Yes --> H[Display Transaction Details] --> I((End))
    G -- No --> I
```

## ۴. Create Category (ساخت دسته)

```mermaid
flowchart TD
    A((Start)) --> B[Open Category Page]
    B --> C[Click Create Category]
    C --> D[Enter Category Name and Type]
    D --> E{Name Long Enough?}
    E -- No --> F[Show Min Length Error] --> D
    E -- Yes --> G{Category Already Exists?}
    G -- Yes --> H[Show Duplicate Error] --> D
    G -- No --> I[Save Category]
    I --> J[Update Category List] --> K((End))
```

## ۵. Transfer Between Accounts (انتقال بین حساب‌ها)

```mermaid
flowchart TD
    A((Start)) --> B[Open Transfer Form]
    B --> C[Select Source and Destination]
    C --> D{Same Account?}
    D -- Yes --> E[Show Error] --> C
    D -- No --> F[Enter Amount]
    F --> G{Is Amount Valid?}
    G -- No --> H[Show Error] --> F
    G -- Yes --> I[Save Transfer]
    I --> J[Update Both Balances] --> K((End))
```

## ۶. Monthly Report (گزارش ماهانه)

```mermaid
flowchart TD
    A((Start)) --> B[Open Report Page]
    B --> C[Select Month]
    C --> D{Is Data Available?}
    D -- No --> E[Show Empty State] --> H((End))
    D -- Yes --> F[Calculate Income, Expense and Net]
    F --> G[Show Chart by Category] --> H
```
