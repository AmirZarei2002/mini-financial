# Scope: Mini Financial (مدیریت مالی شخصی)

یک وب اپ کوچک و فارسی (راست به چپ) برای ثبت درآمد و هزینه شخصی، دسته‌بندی آن‌ها و دیدن گزارش ماهانه. برای پروژه دانشگاه، با مهلت حدود یک ماه.

**Build approach:** Tracer Bullet (هر ویژگی سر تا ته، از دیتابیس تا صفحه، کامل و قابل دمو ساخته می‌شود).
**Workflow:** Alpha (بعد از `/develop`، فقط `/check verify` روی برنامه واقعی). هر ویژگی می‌تواند برچسب خودش را داشته باشد (مثلا `· Beta`).

_این‌ها پیشنهاد هستند، نه الزام. اگر می‌دانید یک ویژگی را چطور بسازید، مستقیم `/develop` بزنید و `/architect` را رد کنید. تصمیم `done` با خود شماست._

## At a glance

| # | Feature | Phase | Status |
|---|---------|-------|--------|
| 1 | Stack & architecture | Foundation | planned |
| 2 | Coding standards & tooling | Foundation | planned |
| 3 | Data model | Foundation | planned |
| 4 | Design system & UI foundation (RTL) | Foundation | planned |
| 5 | Sign up, sign in, first transaction | Slice 1 | planned |
| 6 | Categories | Slice 2 | planned |
| 7 | Transaction list: edit, delete, filter | Slice 3 | planned |
| 8 | Monthly report & dashboard | Slice 4 | planned |

## Foundations

### 1. Stack & architecture · needs a decision
انتخاب فریم‌ورک، دیتابیس و ساختار پروژه، و ساخت یک اسکلت قابل اجرا تا همه بخش‌های بعدی روی آن ساخته شوند.
**Done when:** انتخاب‌ها در یک spec ثبت شده و پروژه خالی به صورت محلی اجرا و build می‌شود.
- [ ] Decide the stack (spec): `/architect stack & architecture`

### 2. Coding standards & tooling
ثبت قراردادهای کدنویسی و نصب lint و format از روی پروژه واقعی.
**Done when:** فایل `AGENTS.md` ریشه با پروژه واقعی می‌خواند و lint و format بدون خطا اجرا می‌شوند.
- [ ] Capture conventions + tooling choices: `/audit`

### 3. Data model · needs a decision
موجودیت‌های اصلی: کاربر، تراکنش (درآمد یا هزینه، مبلغ، تاریخ، توضیح) و دسته‌بندی. تعیین نحوه ذخیره مبلغ (تومان، عدد صحیح) و تاریخ.
**Done when:** مدل داده همه slice ها (دسته‌بندی، فیلتر، گزارش ماهانه) را بدون migration شکننده پوشش می‌دهد و داده هر کاربر از بقیه جداست.
- [ ] Design it (spec): `/architect data model`

### 4. Design system & UI foundation (RTL) · needs a decision
زبان بصری، فونت فارسی، چیدمان راست به چپ، نمایش تاریخ شمسی و قالب اعداد و مبالغ، و کامپوننت‌های پایه (فرم، دکمه، جدول).
**Done when:** `design.md` رنگ، فونت، فاصله و کامپوننت‌ها را پوشش می‌دهد؛ صفحات کاملا RTL هستند؛ تاریخ شمسی و مبالغ با جداکننده هزارگان نمایش داده می‌شوند.
- [ ] Design it (spec): `/architect design system & UI foundation`

## Slice 1: Sign up, sign in, first transaction

### 5. Sign up, sign in, first transaction · needs a decision
ثبت‌نام و ورود ساده، ثبت یک درآمد یا هزینه، و دیدن موجودی فعلی. این slice همان walking skeleton است.
**Done when:** کاربر ثبت‌نام و وارد می‌شود، یک تراکنش ثبت می‌کند و موجودی (درآمد منهای هزینه) را می‌بیند؛ کاربر دیگر داده او را نمی‌بیند؛ خطای فرم نمایش داده می‌شود.
- [ ] Design it (spec): `/architect sign up, sign in, first transaction`

## Slice 2: Categories

### 6. Categories
چند دسته پیش‌فرض (خوراک، حمل و نقل، حقوق، …) به علاوه امکان ساخت دسته جدید، و انتخاب دسته هنگام ثبت تراکنش.
**Done when:** کاربر دسته می‌سازد و ویرایش می‌کند، هر تراکنش یک دسته دارد، و دسته در لیست تراکنش‌ها دیده می‌شود.
- [ ] Build it: `/develop categories`

## Slice 3: Transaction list

### 7. Transaction list: edit, delete, filter
لیست تراکنش‌ها با ویرایش، حذف و فیلتر بر اساس ماه، نوع و دسته.
**Done when:** کاربر تراکنش را ویرایش و حذف می‌کند (با تایید)، فیلتر ماه و دسته کار می‌کند، و حالت خالی نمایش درستی دارد.
- [ ] Build it: `/develop transaction list`

## Slice 4: Monthly report

### 8. Monthly report & dashboard · needs a decision
داشبورد ماهانه: جمع درآمد، جمع هزینه، مانده، و نمودار هزینه به تفکیک دسته.
**Done when:** کاربر یک ماه شمسی را انتخاب می‌کند و جمع‌ها و نمودار دسته‌ها را می‌بیند؛ ماه بدون داده حالت خالی دارد.
- [ ] Design it (spec): `/architect monthly report & dashboard`

## Deferred
خارج از این دور ساخت، برای صادق ماندن برنامه نگه داشته شده.
- **Budgets**: سقف بودجه برای هر دسته و هشدار عبور از آن · needs a decision
- **Export**: خروجی گرفتن از تراکنش‌ها (CSV یا Excel)
- **Recurring transactions**: تراکنش‌های تکراری مثل اجاره و حقوق · needs a decision
- **Password reset**: بازیابی رمز عبور · needs a decision

## Legend

- **Next step** = اولین باکس تیک نخورده.
- **needs a decision** = اول `/architect`، وگرنه مستقیم `/develop` (یا `/audit` برای standards & tooling). بعد از ثبت spec این برچسب حذف می‌شود.
- **Decision box** = باکسی که برچسبش با `(spec)` تمام می‌شود.
- **Status**: `planned` → `in-progress` → `done`، به علاوه `existing` و `dropped`.
- **Workflow** پیش‌فرض Alpha است: بعد از `/develop` فقط `/check verify`. برچسب کنار عنوان (مثلا `· Beta`) آن را برای یک ویژگی تغییر می‌دهد.
- کارهای ریز ساخت در `## Build plan` هر spec هستند، نه اینجا.
- **Pointer line** (`spec <n> · code in <path>`): لینک spec را `/architect` و مسیر کد را `/develop` اضافه می‌کند.
