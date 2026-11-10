PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name     TEXT    NOT NULL,
    email         TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    currency      TEXT    NOT NULL DEFAULT 'IRT',
    created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE accounts (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name            TEXT    NOT NULL,
    type            TEXT    NOT NULL CHECK (type IN ('cash', 'bank', 'card', 'wallet')),
    initial_balance INTEGER NOT NULL DEFAULT 0,
    is_active       INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    created_at      TEXT    NOT NULL DEFAULT (datetime('now')),
    UNIQUE (user_id, name)
);

CREATE TABLE categories (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name       TEXT    NOT NULL,
    type       TEXT    NOT NULL CHECK (type IN ('income', 'expense')),
    color      TEXT,
    created_at TEXT    NOT NULL DEFAULT (datetime('now')),
    UNIQUE (user_id, name, type)
);

CREATE TABLE transactions (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id  INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    type        TEXT    NOT NULL CHECK (type IN ('income', 'expense')),
    amount      INTEGER NOT NULL CHECK (amount > 0),
    occurred_on TEXT    NOT NULL,
    description TEXT,
    created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE transfers (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id         INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    from_account_id INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    to_account_id   INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    amount          INTEGER NOT NULL CHECK (amount > 0),
    occurred_on     TEXT    NOT NULL,
    description     TEXT,
    created_at      TEXT    NOT NULL DEFAULT (datetime('now')),
    CHECK (from_account_id <> to_account_id)
);

CREATE TABLE tags (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name    TEXT    NOT NULL,
    UNIQUE (user_id, name)
);

CREATE TABLE transaction_tags (
    transaction_id INTEGER NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    tag_id         INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    PRIMARY KEY (transaction_id, tag_id)
);

CREATE TABLE budgets (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id      INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id  INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    amount       INTEGER NOT NULL CHECK (amount > 0),
    period_start TEXT    NOT NULL,
    period_end   TEXT    NOT NULL,
    created_at   TEXT    NOT NULL DEFAULT (datetime('now')),
    CHECK (period_end >= period_start),
    UNIQUE (user_id, category_id, period_start)
);

CREATE TABLE recurring_transactions (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id  INTEGER NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    type        TEXT    NOT NULL CHECK (type IN ('income', 'expense')),
    amount      INTEGER NOT NULL CHECK (amount > 0),
    frequency   TEXT    NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly', 'yearly')),
    start_on    TEXT    NOT NULL,
    end_on      TEXT,
    next_run_on TEXT    NOT NULL,
    description TEXT,
    is_active   INTEGER NOT NULL DEFAULT 1 CHECK (is_active IN (0, 1)),
    created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE savings_goals (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id       INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name          TEXT    NOT NULL,
    target_amount INTEGER NOT NULL CHECK (target_amount > 0),
    saved_amount  INTEGER NOT NULL DEFAULT 0 CHECK (saved_amount >= 0),
    deadline      TEXT,
    is_achieved   INTEGER NOT NULL DEFAULT 0 CHECK (is_achieved IN (0, 1)),
    created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_accounts_user              ON accounts (user_id);
CREATE INDEX idx_transactions_user_date     ON transactions (user_id, occurred_on);
CREATE INDEX idx_transactions_account       ON transactions (account_id);
CREATE INDEX idx_transactions_category      ON transactions (category_id);
CREATE INDEX idx_transfers_user_date        ON transfers (user_id, occurred_on);
CREATE INDEX idx_budgets_user_period        ON budgets (user_id, period_start);
CREATE INDEX idx_recurring_next_run         ON recurring_transactions (is_active, next_run_on);

CREATE VIEW v_account_balances AS
SELECT
    a.id AS account_id,
    a.user_id,
    a.name,
    a.type,
    a.initial_balance
      + COALESCE((SELECT SUM(amount) FROM transactions t WHERE t.account_id = a.id AND t.type = 'income'), 0)
      - COALESCE((SELECT SUM(amount) FROM transactions t WHERE t.account_id = a.id AND t.type = 'expense'), 0)
      + COALESCE((SELECT SUM(amount) FROM transfers f WHERE f.to_account_id = a.id), 0)
      - COALESCE((SELECT SUM(amount) FROM transfers f WHERE f.from_account_id = a.id), 0)
      AS balance
FROM accounts a;

CREATE VIEW v_monthly_summary AS
SELECT
    user_id,
    strftime('%Y-%m', occurred_on) AS month,
    SUM(CASE WHEN type = 'income'  THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN type = 'expense' THEN amount ELSE 0 END) AS total_expense,
    SUM(CASE WHEN type = 'income'  THEN amount ELSE -amount END) AS net
FROM transactions
GROUP BY user_id, month;

CREATE VIEW v_category_expenses AS
SELECT
    t.user_id,
    strftime('%Y-%m', t.occurred_on) AS month,
    c.id   AS category_id,
    c.name AS category_name,
    SUM(t.amount) AS total
FROM transactions t
LEFT JOIN categories c ON c.id = t.category_id
WHERE t.type = 'expense'
GROUP BY t.user_id, month, c.id, c.name;

CREATE VIEW v_budget_status AS
SELECT
    b.id AS budget_id,
    b.user_id,
    c.name AS category_name,
    b.period_start,
    b.period_end,
    b.amount AS budget_amount,
    COALESCE(SUM(t.amount), 0) AS spent,
    b.amount - COALESCE(SUM(t.amount), 0) AS remaining,
    CASE WHEN COALESCE(SUM(t.amount), 0) > b.amount THEN 1 ELSE 0 END AS is_over
FROM budgets b
JOIN categories c ON c.id = b.category_id
LEFT JOIN transactions t
       ON t.user_id = b.user_id
      AND t.category_id = b.category_id
      AND t.type = 'expense'
      AND t.occurred_on BETWEEN b.period_start AND b.period_end
GROUP BY b.id;

INSERT INTO categories (user_id, name, type, color) VALUES
    (NULL, 'حقوق',            'income',  '#2e7d32'),
    (NULL, 'پروژه آزاد',      'income',  '#388e3c'),
    (NULL, 'هدیه',            'income',  '#43a047'),
    (NULL, 'سود بانکی',       'income',  '#4caf50'),
    (NULL, 'سایر درآمدها',    'income',  '#66bb6a'),
    (NULL, 'خوراک',           'expense', '#e53935'),
    (NULL, 'رستوران',         'expense', '#d81b60'),
    (NULL, 'حمل و نقل',       'expense', '#8e24aa'),
    (NULL, 'اجاره',           'expense', '#5e35b1'),
    (NULL, 'قبوض',            'expense', '#3949ab'),
    (NULL, 'اینترنت و موبایل', 'expense', '#1e88e5'),
    (NULL, 'تفریح',           'expense', '#00897b'),
    (NULL, 'آموزش',           'expense', '#fb8c00'),
    (NULL, 'سلامت',           'expense', '#f4511e'),
    (NULL, 'پوشاک',           'expense', '#6d4c41'),
    (NULL, 'سایر هزینه‌ها',    'expense', '#757575');

INSERT INTO users (full_name, email, password_hash) VALUES
    ('علی رضایی', 'ali@example.com',  'demo-placeholder-hash'),
    ('سارا احمدی', 'sara@example.com', 'demo-placeholder-hash');

INSERT INTO categories (user_id, name, type, color) VALUES
    (1, 'باشگاه', 'expense', '#c0ca33'),
    (2, 'تدریس خصوصی', 'income', '#7cb342');

INSERT INTO accounts (user_id, name, type, initial_balance) VALUES
    (1, 'کیف پول نقدی',  'cash',   2000000),
    (1, 'حساب بانک ملت', 'bank',   12000000),
    (1, 'کارت اعتباری',  'card',   0),
    (2, 'کیف پول نقدی',  'cash',   1000000),
    (2, 'حساب بانک سامان', 'bank', 6000000);

INSERT INTO transactions (user_id, account_id, category_id, type, amount, occurred_on, description) VALUES
    (1, 2, 1,  'income',  25000000, '2026-08-23', 'حقوق مرداد'),
    (1, 2, 9,  'expense',  8000000, '2026-08-24', 'اجاره خانه'),
    (1, 1, 6,  'expense',   650000, '2026-08-26', 'خرید هفتگی'),
    (1, 1, 8,  'expense',   150000, '2026-08-27', 'تاکسی'),
    (1, 2, 10, 'expense',   850000, '2026-08-30', 'قبض برق و گاز'),
    (1, 2, 11, 'expense',   400000, '2026-09-01', 'بسته اینترنت'),
    (1, 1, 7,  'expense',  1200000, '2026-09-05', 'شام با دوستان'),
    (1, 3, 15, 'expense',  2300000, '2026-09-10', 'کفش ورزشی'),
    (1, 2, 17, 'expense',  1500000, '2026-09-12', 'شهریه باشگاه'),
    (1, 2, 1,  'income',  25000000, '2026-09-22', 'حقوق شهریور'),
    (1, 2, 9,  'expense',  8000000, '2026-09-23', 'اجاره خانه'),
    (1, 1, 6,  'expense',   720000, '2026-09-25', 'خرید هفتگی'),
    (1, 2, 2,  'income',   6000000, '2026-09-28', 'طراحی سایت برای مشتری'),
    (1, 2, 13, 'expense',  3500000, '2026-10-01', 'دوره آموزش برنامه‌نویسی'),
    (1, 1, 8,  'expense',   200000, '2026-10-03', 'مترو و اتوبوس'),
    (1, 2, 14, 'expense',  1800000, '2026-10-07', 'دندانپزشکی'),
    (1, 1, 12, 'expense',   600000, '2026-10-10', 'سینما'),
    (1, 2, 4,  'income',    350000, '2026-10-15', 'سود سپرده'),
    (1, 2, 1,  'income',  25000000, '2026-10-23', 'حقوق مهر'),
    (1, 2, 9,  'expense',  8000000, '2026-10-24', 'اجاره خانه'),
    (1, 1, 6,  'expense',   480000, '2026-10-25', 'خرید میوه'),
    (1, 2, 10, 'expense',   900000, '2026-10-28', 'قبض برق و گاز'),
    (1, 1, 7,  'expense',   950000, '2026-11-02', 'ناهار کاری'),
    (1, 2, 13, 'expense',  1500000, '2026-11-01', 'کتاب درسی'),
    (1, 3, 16, 'expense',   300000, '2026-11-05', 'هدیه تولد'),
    (2, 5, 1,  'income',  18000000, '2026-09-22', 'حقوق شهریور'),
    (2, 5, 9,  'expense',  6500000, '2026-09-23', 'اجاره سهم خوابگاه'),
    (2, 4, 6,  'expense',   550000, '2026-09-26', 'خرید هفتگی'),
    (2, 5, 18, 'income',   4000000, '2026-10-02', 'تدریس ریاضی'),
    (2, 4, 8,  'expense',   180000, '2026-10-04', 'اسنپ'),
    (2, 5, 11, 'expense',   350000, '2026-10-05', 'شارژ موبایل'),
    (2, 5, 3,  'income',   2000000, '2026-10-12', 'هدیه تولد'),
    (2, 5, 1,  'income',  18000000, '2026-10-23', 'حقوق مهر'),
    (2, 5, 9,  'expense',  6500000, '2026-10-24', 'اجاره سهم خوابگاه'),
    (2, 4, 7,  'expense',   800000, '2026-10-30', 'کافه'),
    (2, 5, 15, 'expense',  2700000, '2026-11-03', 'مانتو'),
    (2, 5, 13, 'expense',  1200000, '2026-11-06', 'ثبت‌نام آزمون زبان');

INSERT INTO transfers (user_id, from_account_id, to_account_id, amount, occurred_on, description) VALUES
    (1, 2, 1, 2000000, '2026-08-25', 'برداشت از عابر بانک'),
    (1, 2, 3, 2300000, '2026-09-30', 'تسویه کارت اعتباری'),
    (1, 2, 1, 1500000, '2026-10-26', 'برداشت از عابر بانک'),
    (2, 5, 4, 1000000, '2026-09-24', 'برداشت از عابر بانک');

INSERT INTO tags (user_id, name) VALUES
    (1, 'ضروری'),
    (1, 'دانشگاه'),
    (1, 'دوستان'),
    (2, 'ضروری'),
    (2, 'خوابگاه');

INSERT INTO transaction_tags (transaction_id, tag_id) VALUES
    (2, 1), (5, 1), (7, 3), (11, 1), (14, 2), (20, 1), (23, 3), (24, 2),
    (27, 5), (27, 4), (34, 5), (34, 4), (37, 4);

INSERT INTO budgets (user_id, category_id, amount, period_start, period_end) VALUES
    (1, 6,  3000000, '2026-10-23', '2026-11-21'),
    (1, 7,  1500000, '2026-10-23', '2026-11-21'),
    (1, 12, 1000000, '2026-10-23', '2026-11-21'),
    (1, 13, 2000000, '2026-10-23', '2026-11-21'),
    (2, 6,  2500000, '2026-10-23', '2026-11-21'),
    (2, 15, 2000000, '2026-10-23', '2026-11-21');

INSERT INTO recurring_transactions (user_id, account_id, category_id, type, amount, frequency, start_on, next_run_on, description) VALUES
    (1, 2, 1,  'income',  25000000, 'monthly', '2026-08-23', '2026-11-22', 'حقوق ماهانه'),
    (1, 2, 9,  'expense',  8000000, 'monthly', '2026-08-24', '2026-11-23', 'اجاره خانه'),
    (1, 2, 11, 'expense',   400000, 'monthly', '2026-09-01', '2026-12-01', 'بسته اینترنت'),
    (2, 5, 1,  'income',  18000000, 'monthly', '2026-09-22', '2026-11-22', 'حقوق ماهانه'),
    (2, 5, 9,  'expense',  6500000, 'monthly', '2026-09-23', '2026-11-23', 'اجاره خوابگاه');

INSERT INTO savings_goals (user_id, name, target_amount, saved_amount, deadline) VALUES
    (1, 'خرید لپ‌تاپ',     60000000, 18000000, '2027-03-20'),
    (1, 'صندوق اضطراری',   50000000, 12000000, NULL),
    (2, 'سفر تابستان',     25000000,  7000000, '2027-06-21');
