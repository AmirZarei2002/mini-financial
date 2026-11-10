# Mini Financial | مدیریت مالی شخصی

یک وب اپ کوچک و فارسی (راست به چپ) برای ثبت درآمد و هزینه شخصی، دسته‌بندی آن‌ها و دیدن گزارش ماهانه. پروژه دانشگاهی.

## وضعیت

در مرحله برنامه‌ریزی. برنامه کامل ویژگی‌ها در [docs/scope/scope.md](docs/scope/scope.md) است.

## دیتابیس

فایل [database/schema.sql](database/schema.sql) شامل جدول‌های `users`، `categories` و `transactions`، دسته‌های پیش‌فرض و داده نمونه است.

ساخت دیتابیس با SQLite:

```bash
sqlite3 mini_financial.db < database/schema.sql
```
