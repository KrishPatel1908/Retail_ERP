# FUNCTIONS.md

# Retail ERP Functional Documentation

This document describes every module available in the Retail ERP.

Each module contains:

- Purpose
- Features
- Dependencies
- Status
- Future Scope

---

# MASTER ENTRY

Master Entry stores the fundamental information used throughout the ERP.

Without Master Entry, transactions cannot function.

---

# Company Settings

Purpose

Stores the single company configuration used by every module (Product
Master, Purchase, Sales/POS, Invoices, Reports, GST Reports).

Features

- Company Profile View (LinkedIn / Instagram style hero banner with cover photo background, avatar, business type, GST verified badge, contact pills, and structured identity/address/tax/financial/bank overview cards)
- Profile Cover Banner (custom background banner image upload/change/remove directly from the profile view hero, outside edit mode)
- Company Logo (placed at top with upload / replace / remove with preview; PNG/JPG/WEBP/BMP, up to 5 MB, stored as a file reference outside the database)
- Company Information (Business Name, Business Type, GST Registered toggle, GSTIN, PAN, CIN, Phone, Email, Website)
- Business Address (Address 1 & Address 2, City, State, Pincode, Country — defaults to India)
- Tax & Billing (Default Tax Type, Invoice Prefix, Starting Invoice Number, GST Registered reuse)
- Financial Settings (Financial Year Start, Currency, Currency Symbol, Decimal Places)
- Bank Details (Bank Name, Account Name, Account Number, IFSC, Branch, UPI — all optional, validated when provided)
- Seamless Edit Mode with Cancel and Save Actions (saving persists atomically and transitions to the rich Profile View)
- Skeleton loading state, error state with retry, and atomic save with success/error notifications

Business Rules

- Exactly one company configuration exists (singleton row, `CHECK (id = 1)`);
  saves upsert the same row and can never create a second company.
- The configuration is cached by the application service so unrelated pages
  never repeat the database query.
- GSTIN is required and format-validated when GST registration is enabled.
- CIN is required for LLP / Private Limited / Public Limited business types.
- Values are validated at the UI and application layers; the database
  enforces the singleton and required business name.

Used By

Every module.

Status

Completed

---

# Category

Purpose

Groups products into major categories.

Example

Electronics

Groceries

Furniture

Features

- Create
- Edit
- Delete
- Search

Used By

Product Master

Status

Completed

---

# Sub Category

Purpose

Creates smaller groups inside categories.

Example

Category

Electronics

↓

Laptop

Mouse

Keyboard

Used By

Product Master

Status

Pending

---

# Brand

Purpose

Stores product manufacturers/brands.

Example

Apple

Samsung

Nike

Amul

Features

- Create
- Edit
- Delete (blocked if products reference the brand)
- Search (by Name and Description)
- Real-time Product Count calculation

Business Rules

- Brand Name is required, unique (case-insensitive), and trimmed.
- Description is optional and trimmed.
- Product count is calculated dynamically from the Product table (never stored in Brand table).
- Deletion is rejected if 1 or more products reference the brand.

Used By

Product Master

Status

Completed

---

# Unit Master

Purpose

Stores available measurement units.

Examples

Piece

Kg

Gram

Liter

Box

Bottle

Packet

Dozen

Features

- Create
- Edit
- Delete
- Search

Status

Completed

---

# Global UOM Conversion

Purpose

Stores universal unit conversions.

Examples

1 Kg = 1000 Gram

1 Meter = 100 Centimeter

1 Dozen = 12 Piece

Business Rule

Applies to every product.

Status

Completed

---

# Product UOM Conversion

Purpose

Stores product-specific conversions.

Example

Banana

1 Dozen = 12 Piece

Chocolate

1 Box = 25 Piece

Priority

Product UOM

↓

Global UOM

↓

No Conversion Found

Business Rules

- Multiple conversions allowed
- One default conversion
- First conversion becomes default automatically

Status

Completed

---

# Tax Category

Purpose

Stores reusable tax templates containing one or more atomic tax component rates (e.g. GST 5%, GST 18%, IGST 18%, Tax Free).

Examples

GST 5% (CGST 2.5% + SGST 2.5%)

GST 18% (CGST 9% + SGST 9%)

IGST 18% (IGST 18%)

GST 28% + CESS (CGST 14% + SGST 14% + CESS 2%)

Tax Free (CGST 0% + SGST 0%)

Features

- Create
- Edit
- Delete (blocked if referenced by products)
- Search (by Name and Description)
- Dynamic Tax Component rows
- Automatic Total Tax calculation
- Preview dialog for tax components

Business Rules

- Tax Category Name is required, unique, and trimmed (max 100 chars).
- At least one Tax Component is required.
- Tax Types cannot repeat inside the same Tax Category.
- Total tax percentage is calculated automatically as the sum of component percentages.
- Deletion is rejected if 1 or more products reference the tax category.

Used By

Product Master

Sales

Purchase

Status

Completed

---

# Tax Type

Purpose

Stores atomic tax component definitions used to build Tax Categories across the ERP.

Examples

GST

CGST

SGST

IGST

CESS

Features

- Create
- Edit
- Delete (blocked if referenced by tax category rates or products)
- Search (by Name and Description)

Business Rules

- Tax Type Name is required, unique (case-insensitive), and trimmed.
- Description is optional and trimmed.
- Deletion is rejected if 1 or more tax category rates or products reference the tax type.

Used By

Tax Category

Product Master

Sales

Purchase

Status

Completed

---

# HSN Master

Purpose

Stores HSN codes used to classify products for tax purposes.

Features

- Create
- Edit
- Delete (blocked if referenced by products)
- Search (by HSN Code and Description)
- Default Tax Category dropdown
- Real-time Product Count calculation

Business Rules

- HSN Code is required, unique (case-insensitive), stored upper-cased, and trimmed.
- Description is required and trimmed.
- Default Tax Category is optional and links the code to a Tax Category template.
- Notes are optional and trimmed.
- Product count is calculated dynamically from the Product table (never stored in HSN Master table).
- Deletion is rejected if 1 or more products reference the HSN code.

Used By

Product Master

Status

Completed

---

# Warehouse Master

Purpose

Stores warehouse information.

Features

Warehouse Name

Address

Contact

Used By

Inventory

Purchase

Sales

Product

Status

Pending

---

# Customer Master

Purpose

Stores customer details for sales and receivables.

Features

- View (6-section structured read-only detail modal displaying Basic Info, Contact, Address, Financial Details, Bank Details, System Info)
- Create
- Edit (preserves original Created Date, updates Updated Date timestamp)
- Delete (blocked if used in transactions)
- Search (multi-field across Code, Name, Contact No., Email, GST Number, PAN, City, State, Address Line 1 & 2, Pincode)
- Filters (Status, City, State, Opening Balance options, Payment Due Date range, Created Date range)
- Sorting (Code, Name, Contact No., Opening Balance, Payment Due Date, City, State, Credit Limit, Created Date)
- Pagination (server-side)
- 11-Column Table Layout (Action, Customer Code, Status, Customer Name, Contact No., Opening Balance, Payment Due Date, City, State, Credit Limit, Created Date)
- Auto-generated Customer Code (CUS00001, CUS00002, ...)
- Financial & Bank Details (Opening Balance, Balance Type, Credit Limit, Payment Due Date, Account Name, Account Number, Bank Name, Branch Name, IFSC Code)
- Duplicate prevention (GST Number, Email)
- Enter key focus traversal and automatic scroll-to-first-error on save

Business Rules

- Customer Name is required and trimmed (max 120 chars).
- Contact No. (Mobile) is required and validated as a 10-digit Indian number (digits only, max 10).
- Alternate Mobile is optional; if entered, validated as a 10-digit Indian number (digits only, max 10).
- GST Number (15 chars, uppercase), PAN (10 chars, uppercase), Email (valid email format), Pincode (6 digits), IFSC Code (11 chars, e.g. SBIN0001234) and Account Number are validated when provided; optional fields do not show errors when empty.
- Opening Balance and Credit Limit accept valid non-negative numeric values.
- Created Date is immutable during edits; only Updated Date updates to current timestamp.
- Balances are stored in paise; the outstanding balance starts from the opening balance and is maintained by the future transaction engine.
- Deletion is rejected once the customer is used in invoices, sales, purchases, payments or the ledger: "This record is already used in transactions and cannot be deleted."

Used By

Sales (POS)

Customer Ledger

Customer Statement

GST Reports

Status

Completed

---

# Supplier Master

Purpose

Stores supplier information for purchases and payables.

Features

- View (6-section structured read-only detail modal displaying Basic Info, Contact, Address, Financial Details, Bank Details, System Info)
- Create
- Edit (preserves original Created Date, updates Updated Date timestamp)
- Delete (blocked if used in transactions)
- Search (multi-field across Code, Business Name, Contact Person, Contact No., Email, GST Number, PAN, City, State, Address Line 1 & 2, Pincode)
- Filters (Status, City, State, Opening Balance options, Payment Due Date range, Created Date range)
- Sorting (Code, Name, Contact No., Opening Balance, Payment Due Date, City, State, Credit Limit, Created Date)
- Pagination (server-side)
- 11-Column Table Layout (Action, Supplier Code, Status, Business Name, Contact No., Opening Balance, Payment Due Date, City, State, Credit Limit, Created Date)
- Auto-generated Supplier Code (SUP00001, SUP00002, ...)
- Financial & Bank Details (Opening Balance, Balance Type, Credit Limit, Payment Due Date, Account Name, Account Number, Bank Name, Branch Name, IFSC Code)
- Duplicate prevention (GST Number, Email)
- Enter key focus traversal and automatic scroll-to-first-error on save

Business Rules

- Business Name is required and trimmed (max 120 chars).
- Contact No. (Mobile) is required and validated as a 10-digit Indian number (digits only, max 10).
- Alternate Mobile is optional; if entered, validated as a 10-digit Indian number (digits only, max 10).
- GST Number (15 chars, uppercase), PAN (10 chars, uppercase), Email (valid email format), Pincode (6 digits), IFSC Code (11 chars, e.g. SBIN0001234) and Account Number are validated when provided; optional fields do not show errors when empty.
- Opening Balance and Credit Limit accept valid non-negative numeric values.
- Created Date is immutable during edits; only Updated Date updates to current timestamp.
- Balances are stored in paise; the outstanding balance starts from the opening balance and is maintained by the future transaction engine.
- Deletion is rejected once the supplier is used in purchases, payments or the ledger: "This record is already used in transactions and cannot be deleted."

Used By

Purchase

Supplier Ledger

Supplier Statement

GST Reports

Status

Completed

---

# Product Master

Purpose

The heart of the ERP.

Stores every product.

Dependencies

Category

Sub Category

Brand

Unit

Global UOM

Product UOM

Tax Category

Tax Type

Warehouse

HSN

Features

Product Code

Barcode

Pricing

Stock

Images

Inventory

Status

Pending

---

# INVENTORY

Purpose

Manage stock.

Future Features

Opening Stock

Stock Adjustment

Stock Transfer

Low Stock

Stock Ledger

Status

Pending

---

# PURCHASE

Purpose

Purchase products from suppliers.

Features

Purchase Order

Purchase Entry

Purchase Return

Supplier Ledger

Status

Pending

---

# SALES

Purpose

Sell products.

Features

POS

Invoice

Sales Return

Customer Ledger

Barcode Billing

Status

Pending

---

# REPORTS

Purpose

Business analytics.

Future Reports

Sales

Purchase

Profit

GST

Stock

Customer

Supplier

Status

Pending

---

# DASHBOARD

Purpose

Business overview.

Widgets

Today's Sales

Today's Purchase

Low Stock

Top Products

Monthly Sales

Revenue

Status

Pending

---

# USER MANAGEMENT

Purpose

Manage ERP users.

Future Features

Roles

Permissions

Login

Audit Log

Status

Pending

---

# BACKUP

Purpose

Protect data.

Features

Backup Database

Restore Database

Automatic Backup

Status

Pending

---

# AI ASSISTANT

Purpose

Help users interact with the ERP.

Future Features

Natural Language Search

Voice Commands

Business Insights

Inventory Suggestions

Sales Analysis

Status

Future

---

# DEVELOPMENT ROADMAP

Foundation

✅ Completed

↓

Master Entry

🔄 In Progress

↓

Inventory

↓

Purchase

↓

Sales

↓

Reports

↓

Dashboard

↓

User Management

↓

Backup

↓

AI Assistant

---

# CURRENT PROGRESS

Completed

✅ Category

✅ Sub Category

✅ Unit Master

✅ Global UOM Conversion

✅ Product UOM Conversion

✅ Brand

✅ Tax Type

✅ Tax Category

✅ Customer Master

✅ Supplier Master

✅ Company Settings

Customer and Supplier list pages provide a single combined search-and-filter
panel. Their forms validate before saving and move focus/scroll position to
the first invalid field in their explicit keyboard sequence.

Pending

⬜ Warehouse Master

⬜ Product Master

The ERP follows a dependency-first approach, meaning foundational modules are completed before dependent modules to minimize future refactoring.
