# DATABASE.md

# Database Documentation

This document describes the database schema, table structures, relationships, and constraints in the Retail ERP.

Database Engine: SQLite (via Drift ORM)

---

## Tables Overview

### 1. `brand` (`Brands`)
Product manufacturer dictionary.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `brand_code` | Text | Unique, Non-null | Internal brand code |
| `brand_name` | Text | Non-null | Brand Name (case-insensitive unique index) |
| `description` | Text | Nullable | Optional description |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Case-insensitive unique index `idx_brand_name_nocase_unique` on `brand_name`.
- `productCount` is **never stored** in the `brand` table; it is dynamically calculated at query time via `LEFT OUTER JOIN` with `product.brand_id`.
- Foreign key deletion restriction: A Brand cannot be deleted if referenced by 1 or more products in `product`.

---

### 2. `category` (`Categories`)
Major product category dictionary.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `category_code` | Text | Unique, Non-null | Sequential code (`CAT-0001`) |
| `category_name` | Text | Non-null | Category Name |
| `description` | Text | Nullable | Optional description |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

---

### 3. `unit` (`Units`)
Units of Measurement.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `unit_name` | Text | Unique, Non-null | Unit name (e.g., Piece, Box) |
| `unit_symbol` | Text | Non-null | Short symbol (e.g., pc, box) |
| `unit_family` | Text | Default `'COUNT'` | Unit family category |
| `description` | Text | Nullable | Optional description |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

---

### 4. `uom_conversion` (`UomConversions`)
Global unit conversion definitions.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `from_unit_id` | Integer | References `unit(id)` | Source unit |
| `to_unit_id` | Integer | References `unit(id)` | Target unit |
| `conversion_factor` | Real | Check > 0 | Multiplier factor |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

---

### 5. `product_uom_conversion` (`ProductUomConversions`)
Product-specific unit conversions overriding global conversions.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `product_id` | Integer | References `product(id)` | Target product |
| `from_unit_id` | Integer | References `unit(id)` | Source unit |
| `to_unit_id` | Integer | References `unit(id)` | Target unit |
| `conversion_factor` | Real | Check > 0 | Multiplier factor |
| `is_default` | Boolean | Default `false` | Default conversion flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

---

### 6. `product` (`Products`)
Product master details referencing `brand`, `category`, `unit`, `tax_type`, etc.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `product_code` | Text | Unique, Non-null | Product code |
| `product_name` | Text | Non-null | Product name |
| `brand_id` | Integer | Nullable, References `brand(id)` | Foreign key to Brand |
| `category_id` | Integer | Nullable, References `category(id)` | Foreign key to Category |
| `sub_category_id` | Integer | Nullable, References `sub_category(id)` | Foreign key to SubCategory |
| `unit_id` | Integer | Non-null, References `unit(id)` | Base unit of measurement |
| `selling_price` | Integer | Default `0`, `CHECK (selling_price >= 0)` | Base selling price in paise |
| `purchase_price` | Integer | Nullable, `CHECK (purchase_price >= 0)` | Optional purchase price in paise |
| `mrp` | Integer | Nullable, `CHECK (mrp >= 0)` | Optional MRP in paise |
| `wholesale_price` | Integer | Nullable, `CHECK (wholesale_price >= 0)` | Optional wholesale price in paise |
| `barcode` | Text | Nullable | Optional unique barcode / SKU |
| `hsn_code` | Text | Nullable | Optional HSN/SAC code |
| `tax_type_id` | Integer | Nullable, References `tax_type(id)` | Tax type |
| `expiry_date` | DateTime | Nullable | Optional product expiry date |
| `notes` | Text | Nullable | Optional notes |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Partial unique index `idx_product_barcode_unique` on `barcode WHERE barcode IS NOT NULL AND barcode != ''`.
- Search indexes on `product_name`, `product_code`, `barcode`, `category_id`, `brand_id`, `created_at`.

---

### 6.1 `product_variant` (`ProductVariants`)
Product variants inheriting parent product's category, brand, unit, and tax attributes with specific pricing/barcode.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `product_id` | Integer | References `product(id)` ON DELETE CASCADE | Parent product foreign key |
| `variant_name` | Text | Non-null | Variant name (e.g. 50g Small Pack) |
| `selling_price` | Integer | Non-null, `CHECK (selling_price >= 0)` | Variant selling price in paise |
| `purchase_price` | Integer | Nullable, `CHECK (purchase_price >= 0)` | Optional variant purchase price in paise |
| `mrp` | Integer | Nullable, `CHECK (mrp >= 0)` | Optional variant MRP in paise |
| `wholesale_price` | Integer | Nullable, `CHECK (wholesale_price >= 0)` | Optional variant wholesale price in paise |
| `barcode` | Text | Nullable | Optional unique barcode / SKU |
| `hsn_code` | Text | Nullable | Optional HSN/SAC code |
| `expiry_date` | DateTime | Nullable | Optional variant expiry date |
| `notes` | Text | Nullable | Optional notes |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Unique constraint `(product_id, variant_name)` ensures unique variant names per product.
- Partial unique index `idx_variant_barcode_unique` on `barcode WHERE barcode IS NOT NULL AND barcode != ''`.

---

### 7. `tax_type` (`TaxTypes`)
Atomic tax components (GST, CGST, SGST, IGST, CESS).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `tax_type_code` | Text | Non-null | Internal tax type code |
| `tax_type_name` | Text | Non-null | Tax Type Name (e.g. GST, CGST, SGST) |
| `description` | Text | Nullable | Optional description |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Referenced By:**
- `tax_category_rate.tax_type_id`
- `product.tax_type_id`

**Rules:**
- Deletion restriction: A Tax Type cannot be deleted if referenced by any record in `tax_category_rate` or `product`.

---

### 8. `tax_category` (`TaxCategories`)
Reusable tax templates containing one or more atomic tax components (e.g. GST 18%, Tax Free).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `tax_category_code` | Text | Unique, Non-null | Internal tax category code |
| `tax_category_name` | Text | Non-null | Tax Category Name (e.g. GST 18%, Tax Free) |
| `description` | Text | Nullable | Optional description |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Referenced By:**
- `tax_category_rate.tax_category_id`
- `product.tax_category_id`

**Rules:**
- Deletion restriction: A Tax Category cannot be deleted if referenced by 1 or more products in `product`.

---

### 9. `tax_category_rate` (`TaxCategoryRates`)
Atomic component rate breakdown attached to a Tax Category.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `tax_category_id` | Integer | References `tax_category(id)` | Parent tax category |
| `tax_type_id` | Integer | References `tax_type(id)` | Referenced atomic tax type |
| `rate_percent` | Real | Check >= 0 AND <= 100 | Component tax percentage |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Index `idx_rate_tax_category` on `tax_category_id`.
- Index `idx_rate_tax_type` on `tax_type_id`.
- Composite unique key `{tax_category_id, tax_type_id}` prevents duplicate tax types inside the same category.

---

### 10. `customer` (`Customers`)
Customer master for sales/receivables (schema v5 shape).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `customer_code` | Text | Unique, Non-null | Auto-generated code (`CUS00001`) |
| `customer_name` | Text | Non-null | Customer name |
| `gst_number` | Text | Nullable | GSTIN (case-insensitive unique) |
| `pan_number` | Text | Nullable | PAN |
| `mobile` | Text | Nullable | Contact No. |
| `alternate_mobile` | Text | Nullable | Alternate mobile |
| `email` | Text | Nullable | Email (case-insensitive unique) |
| `address_line1` | Text | Nullable | First address line |
| `address_line2` | Text | Nullable | Second address line |
| `city` | Text | Nullable | City |
| `state` | Text | Nullable | State |
| `state_code` | Text | Nullable | Two-digit state code (for GST reports) |
| `country` | Text | Nullable | Country |
| `pincode` | Text | Nullable | Pincode |
| `credit_limit` | Integer | Default `0` | Max credit allowed (paise) |
| `opening_balance` | Integer | Default `0` | Opening balance (paise) |
| `outstanding_balance` | Integer | Default `0` | Cached balance (paise), maintained by transaction engine |
| `balance_type` | Text | Default `'DEBIT'` | `DEBIT` or `CREDIT` |
| `payment_due_date` | DateTime | Nullable | Optional payment due date |
| `account_name` | Text | Nullable | Bank account holder name |
| `account_number` | Text | Nullable | Bank account number |
| `bank_name` | Text | Nullable | Bank name |
| `branch_name` | Text | Nullable | Bank branch name |
| `ifsc_code` | Text | Nullable | Indian Financial System Code |
| `notes` | Text | Nullable | Optional notes |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Case-insensitive unique index `idx_customer_gst_nocase_unique` on `gst_number`.
- Case-insensitive unique index `idx_customer_email_nocase_unique` on `email`.
- Lookup indexes `idx_customer_city`, `idx_customer_state`, `idx_customer_created_at`, `idx_customer_name`, `idx_customer_active_name`.
- Deletion restriction: a customer used in invoices, sales, purchases, payments or the ledger cannot be deleted (guard is future-proof for transaction tables).

---

### 11. `supplier` (`Suppliers`)
Supplier master for purchases/payables (schema v5 shape).

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, Auto Increment | Unique Identifier |
| `supplier_code` | Text | Unique, Non-null | Auto-generated code (`SUP00001`) |
| `supplier_name` | Text | Non-null | Business name |
| `contact_person` | Text | Nullable | Contact person |
| `gst_number` | Text | Nullable | GSTIN (case-insensitive unique) |
| `pan_number` | Text | Nullable | PAN |
| `mobile` | Text | Nullable | Contact No. |
| `alternate_mobile` | Text | Nullable | Alternate mobile |
| `email` | Text | Nullable | Email (case-insensitive unique) |
| `address_line1` | Text | Nullable | First address line |
| `address_line2` | Text | Nullable | Second address line |
| `city` | Text | Nullable | City |
| `state` | Text | Nullable | State |
| `state_code` | Text | Nullable | Two-digit state code (for GST reports) |
| `country` | Text | Nullable | Country |
| `pincode` | Text | Nullable | Pincode |
| `credit_limit` | Integer | Default `0` | Max credit allowed (paise) |
| `opening_balance` | Integer | Default `0` | Opening balance (paise) |
| `outstanding_balance` | Integer | Default `0` | Cached balance (paise), maintained by transaction engine |
| `balance_type` | Text | Default `'DEBIT'` | `DEBIT` or `CREDIT` |
| `payment_due_date` | DateTime | Nullable | Optional payment due date |
| `payment_terms` | Text | Nullable | Payment terms (e.g. `Net 30`) |
| `account_name` | Text | Nullable | Bank account holder name |
| `account_number` | Text | Nullable | Bank account number |
| `bank_name` | Text | Nullable | Bank name |
| `branch_name` | Text | Nullable | Bank branch name |
| `ifsc_code` | Text | Nullable | Indian Financial System Code |
| `notes` | Text | Nullable | Optional notes |
| `is_active` | Boolean | Default `true` | Active status flag |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Indexes & Rules:**
- Case-insensitive unique index `idx_supplier_gst_nocase_unique` on `gst_number`.
- Case-insensitive unique index `idx_supplier_email_nocase_unique` on `email`.
- Lookup indexes `idx_supplier_city`, `idx_supplier_state`, `idx_supplier_created_at`, `idx_supplier_name`, `idx_supplier_active_name`.
- Deletion restriction: a supplier used in purchases, payments or the ledger cannot be deleted (guard is future-proof for transaction tables).

---

### 12. `company_settings` (`CompanySettingsTable`)
Single-row company configuration (schema v6 shape). There is exactly one row
in the whole database — `CHECK (id = 1)` rejects a second row, and the
repository/service layer only ever read and write `id = 1`.

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | Integer | Primary Key, `CHECK (id = 1)` | Singleton company row |
| `company_name` | Text | Non-null | Business name shown throughout the ERP |
| `legal_name` | Text | Nullable | Legal name |
| `business_type` | Text | Default `'PROPRIETORSHIP'` | `PROPRIETORSHIP`, `PARTNERSHIP`, `LLP`, `PRIVATE_LIMITED`, `PUBLIC_LIMITED`, `OTHER` |
| `gst_registered` | Boolean | Default `false` | Whether the business is GST registered; GSTIN becomes required when true |
| `gst_number` | Text | Nullable | GSTIN (15 chars, stored upper-case) |
| `pan_number` | Text | Nullable | PAN (10 chars, stored upper-case) |
| `cin` | Text | Nullable | CIN; required for LLP / Private / Public Limited |
| `mobile` | Text | Nullable | Phone (Indian mobile or landline) |
| `email` | Text | Nullable | Email (stored lower-case) |
| `website` | Text | Nullable | Website URL |
| `address_line1` | Text | Nullable | First address line (renamed from `address` in v6) |
| `address_line2` | Text | Nullable | Second address line |
| `city` | Text | Nullable | City |
| `state` | Text | Nullable | State |
| `state_code` | Text | Nullable | Two-digit state code derived from the GSTIN (for GST reports) |
| `country` | Text | Nullable | Country (UI defaults to `India`) |
| `pincode` | Text | Nullable | Pincode (6 digits) |
| `logo_path` | Text | Nullable | Absolute path of the logo file; the image bytes are stored **outside** the database |
| `prices_inclusive_of_tax` | Boolean | Default `false` | Default tax type: `true` = Tax Inclusive, `false` = Tax Exclusive |
| `invoice_prefix` | Text | Default `'INV-'` | Invoice number prefix |
| `invoice_start_number` | Integer | Default `1` | Starting invoice number |
| `purchase_prefix` | Text | Default `'PUR-'` | Purchase number prefix (reserved) |
| `receipt_prefix` | Text | Default `'RCT-'` | Receipt number prefix (reserved) |
| `financial_year_start_month` | Integer | Default `4` | Financial year start month (1–12, April default) |
| `currency_code` | Text | Default `'INR'` | ISO currency code |
| `currency_symbol` | Text | Default `'₹'` | Currency symbol |
| `decimal_places` | Integer | Default `2` | Decimal places for amounts |
| `timezone` | Text | Default `'Asia/Kolkata'` | Business timezone |
| `bank_name` | Text | Nullable | Bank name |
| `bank_account_name` | Text | Nullable | Bank account holder name |
| `bank_account_number` | Text | Nullable | Bank account number |
| `bank_ifsc` | Text | Nullable | IFSC code (stored upper-case) |
| `bank_branch` | Text | Nullable | Bank branch |
| `upi_id` | Text | Nullable | UPI ID |
| `invoice_footer` | Text | Nullable | Invoice footer text |
| `invoice_terms` | Text | Nullable | Invoice terms & conditions |
| `invoice_thank_you_message` | Text | Nullable | Invoice thank-you message |
| `show_logo_on_invoice` | Boolean | Default `true` | Show logo on generated documents |
| `show_bank_details_on_invoice` | Boolean | Default `true` | Show bank details on generated documents |
| `show_gst_details_on_invoice` | Boolean | Default `true` | Show GST details on generated documents |
| `is_active` | Boolean | Default `true` | Activity flag (reserved) |
| `created_at` | DateTime | Default `now()` | Record creation timestamp |
| `updated_at` | DateTime | Default `now()` | Record update timestamp |

**Rules:**
- Exactly one row may exist (`CHECK (id = 1)`); `CompanySettingsRepository.getOrCreate()` creates the default row on first access and `save()` upserts it atomically in a transaction.
- The application layer (`CompanySettingsService`) caches the loaded configuration process-wide, so unrelated pages never repeat the lookup.
- Fields not surfaced in the settings UI (prefixes, timezone, `is_active`) are preserved through saves.
- No additional indexes: the table is a single primary-key row — an index would be pure overhead.

---

## Migrations History

- **v1 → v4**: Initial setup and tax/party table additions.
- **v4 → v5 (`upgradeToV5`)**: Added `payment_due_date`, `account_name`, `account_number`, `bank_name`, `branch_name`, `ifsc_code` to `customer`, and `credit_limit`, `payment_due_date`, `account_name`, `account_number`, `bank_name`, `branch_name`, `ifsc_code` to `supplier`.
- **v5 → v6 (`upgradeToV6`)**: Expanded `company_settings` into the full Company Settings module.
- **v6 → v7 (`upgradeToV7`)**: Rebuilt `product` table to simplified model.
- **v7 → v8 (`upgradeToV8`)**: Added `expiry_date` to `product`, removed obsolete tracking flags, and introduced `product_variant` table.
- **v8 → v9 (`upgradeToV9`)**: Added Purchase module tables (`purchase`, `purchase_item`, `inventory_transaction`, `current_stock`).
- **v9 → v10 (`upgradeToV10`)**: Added `purchase_price`, `mrp`, `wholesale_price`, `barcode`, and `hsn_code` to both `product` and `product_variant` tables; created partial unique indexes on non-empty barcodes.
- **v10 → v11 (`upgradeToV11`)**: Removed the deferred multi-warehouse feature — dropped the `warehouse` table and its unique index, and rebuilt `inventory_transaction` and `current_stock` without their always-empty `warehouse_id` column. Every existing row is preserved. The rebuilt `current_stock` uses a unique index on `(product_id, variant_id)` in place of the inline `UNIQUE` constraint, so upgraded and freshly-created databases converge on an identical shape.

## UI and keyboard behavior

Customer and Supplier master UI and focus-navigation improvements do not
change the database schema, migrations, or CRUD persistence rules.
