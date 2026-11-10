PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name     TEXT    NOT NULL,
    email         TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE categories (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id    INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name       TEXT    NOT NULL,
    type       TEXT    NOT NULL CHECK (type IN ('income', 'expense')),
    created_at TEXT    NOT NULL DEFAULT (datetime('now')),
    UNIQUE (user_id, name, type)
);

CREATE TABLE transactions (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    type        TEXT    NOT NULL CHECK (type IN ('income', 'expense')),
    amount      INTEGER NOT NULL CHECK (amount > 0),
    occurred_on TEXT    NOT NULL,
    description TEXT,
    created_at  TEXT    NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_transactions_user_date ON transactions (user_id, occurred_on);
CREATE INDEX idx_transactions_category  ON transactions (category_id);

INSERT INTO categories (user_id, name, type) VALUES
    (NULL, 'حقوق',         'income'),
    (NULL, 'هدیه',         'income'),
    (NULL, 'سایر درآمدها', 'income'),
    (NULL, 'خوراک',        'expense'),
    (NULL, 'حمل و نقل',    'expense'),
    (NULL, 'اجاره',        'expense'),
    (NULL, 'قبوض',         'expense'),
    (NULL, 'تفریح',        'expense'),
    (NULL, 'آموزش',        'expense'),
    (NULL, 'سایر هزینه‌ها', 'expense');

INSERT INTO users (full_name, email, password_hash) VALUES
    ('کاربر نمونه', 'demo@example.com', 'demo-placeholder-hash');

INSERT INTO transactions (user_id, category_id, type, amount, occurred_on, description) VALUES
    (1, 1, 'income',  25000000, '2026-10-23', 'حقوق مهر'),
    (1, 6, 'expense',  8000000, '2026-10-24', 'اجاره خانه'),
    (1, 4, 'expense',   450000, '2026-10-25', 'خرید میوه'),
    (1, 5, 'expense',   120000, '2026-10-26', 'تاکسی'),
    (1, 7, 'expense',   900000, '2026-10-28', 'قبض برق و گاز'),
    (1, 9, 'expense',  1500000, '2026-11-01', 'کتاب درسی'),
    (1, 8, 'expense',   600000, '2026-11-03', 'سینما');

