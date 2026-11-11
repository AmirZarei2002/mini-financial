# Mini Financial | مدیریت مالی شخصی

یک وب اپ کوچک و فارسی (راست به چپ) برای ثبت درآمد و هزینه شخصی، دسته‌بندی آن‌ها و دیدن گزارش ماهانه. پروژه دانشگاهی.

## وضعیت

در مرحله برنامه‌ریزی. برنامه کامل ویژگی‌ها در [docs/scope/scope.md](docs/scope/scope.md) است.

## دیتابیس

فایل [database/schema.sql](database/schema.sql) شامل ۹ جدول (کاربران، حساب‌ها، دسته‌ها، تراکنش‌ها، انتقال بین حساب‌ها، برچسب‌ها، بودجه، تراکنش‌های تکراری و اهداف پس‌انداز)، ۴ view گزارش (موجودی حساب‌ها، خلاصه ماهانه، هزینه به تفکیک دسته، وضعیت بودجه) و داده نمونه برای دو کاربر است.

ساخت دیتابیس با SQLite:

```bash
sqlite3 mini_financial.db < database/schema.sql
```

## مستندات

- [SRS](docs/srs.md)
- [Use Cases](docs/use-cases.md)
- [Activity Diagrams](docs/activity-diagrams.md)
- [Class Diagram](docs/class-diagram.md)
- [DB Tables](docs/database.md)
