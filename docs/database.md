# طراحی دیتابیس سیستم مدیریت مالی شخصی

## نمودار ER

```mermaid
erDiagram
    users ||--o{ accounts : "دارد"
    users ||--o{ categories : "دسته شخصی"
    users ||--o{ transactions : "ثبت می‌کند"
    users ||--o{ transfers : "انجام می‌دهد"
    users ||--o{ tags : "دارد"
    users ||--o{ budgets : "تعیین می‌کند"
    users ||--o{ recurring_transactions : "تعریف می‌کند"
    users ||--o{ savings_goals : "دارد"
    accounts ||--o{ transactions : "شامل"
    accounts ||--o{ transfers : "مبدأ"
    accounts ||--o{ transfers : "مقصد"
    accounts ||--o{ recurring_transactions : "شامل"
    categories ||--o{ transactions : "دسته‌بندی"
    categories ||--o{ budgets : "بودجه"
    categories ||--o{ recurring_transactions : "دسته‌بندی"
    transactions ||--o{ transaction_tags : "دارد"
    tags ||--o{ transaction_tags : "دارد"

    users {
        INTEGER id PK
        TEXT full_name
        TEXT email UK
        TEXT password_hash
        TEXT currency
        TEXT created_at
    }
    accounts {
        INTEGER id PK
        INTEGER user_id FK
        TEXT name
        TEXT type
        INTEGER initial_balance
        INTEGER is_active
        TEXT created_at
    }
    categories {
        INTEGER id PK
        INTEGER user_id FK
        TEXT name
        TEXT type
        TEXT color
        TEXT created_at
    }
    transactions {
        INTEGER id PK
        INTEGER user_id FK
        INTEGER account_id FK
        INTEGER category_id FK
        TEXT type
        INTEGER amount
        TEXT occurred_on
        TEXT description
        TEXT created_at
    }
    transfers {
        INTEGER id PK
        INTEGER user_id FK
        INTEGER from_account_id FK
        INTEGER to_account_id FK
        INTEGER amount
        TEXT occurred_on
        TEXT description
        TEXT created_at
    }
    tags {
        INTEGER id PK
        INTEGER user_id FK
        TEXT name
    }
    transaction_tags {
        INTEGER transaction_id PK,FK
        INTEGER tag_id PK,FK
    }
    budgets {
        INTEGER id PK
        INTEGER user_id FK
        INTEGER category_id FK
        INTEGER amount
        TEXT period_start
        TEXT period_end
        TEXT created_at
    }
    recurring_transactions {
        INTEGER id PK
        INTEGER user_id FK
        INTEGER account_id FK
        INTEGER category_id FK
        TEXT type
        INTEGER amount
        TEXT frequency
        TEXT start_on
        TEXT end_on
        TEXT next_run_on
        TEXT description
        INTEGER is_active
        TEXT created_at
    }
    savings_goals {
        INTEGER id PK
        INTEGER user_id FK
        TEXT name
        INTEGER target_amount
        INTEGER saved_amount
        TEXT deadline
        INTEGER is_achieved
        TEXT created_at
    }
```

## جداول

### users (کاربران)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| full_name | TEXT | الزامی |
| email | TEXT | الزامی، یکتا |
| password_hash | TEXT | الزامی |
| currency | TEXT | پیش‌فرض IRT |
| created_at | TEXT | زمان ایجاد |

### accounts (حساب‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| name | TEXT | الزامی، یکتا برای هر کاربر |
| type | TEXT | cash، bank، card یا wallet |
| initial_balance | INTEGER | موجودی اولیه |
| is_active | INTEGER | ۰ یا ۱ |
| created_at | TEXT | زمان ایجاد |

### categories (دسته‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users؛ خالی یعنی دسته پیش‌فرض |
| name | TEXT | الزامی |
| type | TEXT | income یا expense |
| color | TEXT | رنگ نمایش |
| created_at | TEXT | زمان ایجاد |

### transactions (تراکنش‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| account_id | INTEGER | کلید خارجی به accounts |
| category_id | INTEGER | کلید خارجی به categories |
| type | TEXT | income یا expense |
| amount | INTEGER | بزرگ‌تر از صفر (تومان) |
| occurred_on | TEXT | تاریخ تراکنش |
| description | TEXT | توضیح |
| created_at | TEXT | زمان ایجاد |

### transfers (انتقال بین حساب‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| from_account_id | INTEGER | کلید خارجی به accounts (مبدأ) |
| to_account_id | INTEGER | کلید خارجی به accounts (مقصد)، مخالف مبدأ |
| amount | INTEGER | بزرگ‌تر از صفر |
| occurred_on | TEXT | تاریخ انتقال |
| description | TEXT | توضیح |
| created_at | TEXT | زمان ایجاد |

### tags (برچسب‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| name | TEXT | یکتا برای هر کاربر |

### transaction_tags (ارتباط تراکنش و برچسب)

| ستون | نوع | قید |
|---|---|---|
| transaction_id | INTEGER | کلید خارجی به transactions، بخشی از کلید اصلی |
| tag_id | INTEGER | کلید خارجی به tags، بخشی از کلید اصلی |

### budgets (بودجه‌ها)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| category_id | INTEGER | کلید خارجی به categories |
| amount | INTEGER | سقف بودجه، بزرگ‌تر از صفر |
| period_start | TEXT | شروع دوره |
| period_end | TEXT | پایان دوره، بعد از شروع |
| created_at | TEXT | زمان ایجاد |

### recurring_transactions (تراکنش‌های تکراری)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| account_id | INTEGER | کلید خارجی به accounts |
| category_id | INTEGER | کلید خارجی به categories |
| type | TEXT | income یا expense |
| amount | INTEGER | بزرگ‌تر از صفر |
| frequency | TEXT | daily، weekly، monthly یا yearly |
| start_on | TEXT | تاریخ شروع |
| end_on | TEXT | تاریخ پایان (اختیاری) |
| next_run_on | TEXT | تاریخ اجرای بعدی |
| description | TEXT | توضیح |
| is_active | INTEGER | ۰ یا ۱ |
| created_at | TEXT | زمان ایجاد |

### savings_goals (اهداف پس‌انداز)

| ستون | نوع | قید |
|---|---|---|
| id | INTEGER | کلید اصلی |
| user_id | INTEGER | کلید خارجی به users |
| name | TEXT | الزامی |
| target_amount | INTEGER | مبلغ هدف، بزرگ‌تر از صفر |
| saved_amount | INTEGER | مبلغ پس‌انداز شده |
| deadline | TEXT | مهلت (اختیاری) |
| is_achieved | INTEGER | ۰ یا ۱ |
| created_at | TEXT | زمان ایجاد |

## روابط

| جدول اول | جدول دوم | نوع رابطه | توضیح |
|---|---|---|---|
| users | accounts | یک به چند | هر کاربر چند حساب دارد |
| users | categories | یک به چند | هر کاربر می‌تواند دسته شخصی بسازد |
| users | transactions | یک به چند | هر کاربر چند تراکنش دارد |
| users | transfers | یک به چند | هر کاربر چند انتقال دارد |
| users | tags | یک به چند | هر کاربر برچسب‌های خودش را دارد |
| users | budgets | یک به چند | هر کاربر چند بودجه دارد |
| users | recurring_transactions | یک به چند | هر کاربر چند تراکنش تکراری دارد |
| users | savings_goals | یک به چند | هر کاربر چند هدف پس‌انداز دارد |
| accounts | transactions | یک به چند | هر تراکنش در یک حساب ثبت می‌شود |
| accounts | transfers | یک به چند (دو بار) | هر انتقال یک حساب مبدأ و یک حساب مقصد دارد |
| accounts | recurring_transactions | یک به چند | هر تراکنش تکراری به یک حساب وصل است |
| categories | transactions | یک به چند | هر تراکنش یک دسته دارد |
| categories | budgets | یک به چند | هر بودجه برای یک دسته است |
| categories | recurring_transactions | یک به چند | هر تراکنش تکراری یک دسته دارد |
| transactions | tags | چند به چند | از طریق جدول transaction_tags |
