# PROJECT_CONTEXT.md

# Retail ERP

## Project Overview

Retail ERP is a production-grade Offline Desktop ERP system developed using Flutter.

The software is designed for retail shops, supermarkets, wholesalers, distributors, and small to medium businesses that require a fast, modern, and offline-first ERP solution.

The application is designed to run completely offline using SQLite while keeping the architecture ready for future cloud synchronization if required.

---

# Vision

Build a modern ERP that is:

- Fast
- Offline First
- Easy to Use
- Modular
- Production Ready
- Cross Platform
- Easy to Maintain
- Scalable

The project should be suitable for real businesses instead of being just a college project.

---

# Target Users

- Retail Shops
- Grocery Stores
- Medical Stores
- Electronics Stores
- Clothing Stores
- Wholesale Businesses
- Distribution Companies

---

# Project Goals

The ERP should allow businesses to manage:

- Products
- Inventory
- Customers
- Suppliers
- Purchases
- Sales
- Warehouses
- Taxes
- Barcode Scanning
- Reports
- Dashboard
- Accounting (Future)

while remaining completely offline.

---

# Platform

Desktop First

Supported Platforms

- Windows
- macOS

Future

- Linux

---

# Architecture

Feature First Architecture

Clean Architecture

Repository Pattern

SQLite

Drift ORM

Material 3

Desktop Responsive UI

---

# Current Development Status

## Foundation

Completed

- Application Structure
- Navigation
- Desktop Shell
- Responsive Sidebar
- Shared Widgets
- Theme
- Database Foundation
- Drift Configuration
- SQLite Integration

---

## Master Entry

Completed

- Category
- Sub Category
- Unit Master
- Global UOM Conversion
- Product UOM Conversion
- Brand
- Tax Type
- Tax Category
- Customer Master
- Supplier Master
- Product Master

Pending

- Warehouse Master

---

# Product Architecture

Product Master depends on

Category

↓

Sub Category

↓

Brand

↓

Unit

↓

Global UOM

↓

Product UOM

↓

Tax Category

↓

Tax Type

↓

HSN

↓

Warehouse

For this reason Product Master is intentionally implemented near the end of Master Entry.

---

# Measurement System

The ERP separates measurements into three layers.

## Unit Master

Stores available units.

Examples

- Piece
- Kg
- Gram
- Box
- Bottle
- Dozen

---

## Global UOM Conversion

Stores universal conversions.

Examples

1 Kg = 1000 Gram

1 Dozen = 12 Piece

These apply to every product.

---

## Product UOM Conversion

Stores product-specific conversions.

Example

Banana

1 Dozen = 12 Piece

Example

Chocolate

1 Box = 25 Piece

Product conversion always overrides Global UOM.

Priority

Product UOM

↓

Global UOM

↓

No Conversion Found

---

# Design Principles

The application focuses on

- Clean UI
- Desktop Experience
- Simple Navigation
- Reusable Components
- Consistent Design
- High Performance

---

# Shared Components

Reusable components include

- AppDataTable
- SearchField
- PageHeader
- Breadcrumbs
- LabelledField
- FormFocusController
- ContentPanel
- Shared Dialogs (CustomerDetailDialog, SupplierDetailDialog)
- Shared Action Buttons (View, Edit, Delete)

Every module should reuse these components instead of creating new ones.

---

# Coding Philosophy

The project follows

- SOLID Principles
- DRY
- KISS
- Clean Code
- Separation of Concerns

---

# Current Roadmap

Master Entry

↓

Inventory

↓

Purchase

↓

Purchase Return

↓

Sales POS

↓

Sales Return

↓

Stock Adjustment

↓

Stock Transfer

↓

Reports

↓

Dashboard

↓

User Management

↓

Role Management

↓

Backup & Restore

↓

AI Assistant

---

# Long-Term Vision

The goal is to build a complete commercial Retail ERP capable of handling thousands of products, multiple warehouses, multiple users, and large daily transaction volumes while remaining fast and maintainable.

The project should serve as a production-ready desktop ERP rather than a demonstration application.

## Party master experience

Customer Master and Supplier Master share one responsive list/filter layout:
the search input and Status, City, State, Balance Type, Due Date and Created
Date filters live in a single panel above the existing data table.

# Company Settings

Company Settings is a **settings page, not a master-entry list**: there is
exactly one company configuration per database. The single row is enforced
at the database level (`CHECK (id = 1)` on `company_settings`) and by the
repository/service layer, which only ever read and write `id = 1`. The
architecture keeps the door open for future multi-company / multi-branch
support without a rewrite.

Access pattern (UI → Controller/Application → Repository → Database):

- `CompanySettingsPage` collects and validates the form.
- `CompanySettingsService` is the central access point for the rest of the
  ERP (Product Master, Purchase, Sales/POS, Invoices, Reports, GST Reports).
  It caches the loaded configuration process-wide — unrelated pages never
  repeat the database query — and re-validates drafts before saving.
- `CompanySettingsRepository` performs a single primary-key lookup for the
  singleton row and saves atomically inside one transaction.

Business rules

- Business name, Address Line 1, City, State, Pincode and Phone are required.
- GSTIN is required (and format-validated) only when GST registration is
  enabled; PAN, CIN, Email, Website, Pincode, IFSC, UPI ID and account
  number are validated when provided.
- CIN is required for incorporated business types (LLP, Private Limited,
  Public Limited).
- The logo is stored as a file (PNG/JPG/WEBP/BMP, max 2 MB) in the
  application support directory; only its path is stored in the database.
- Bank details are optional; the settings only configure future document
  rendering (invoice footer, terms, thank-you, and show-logo / bank / GST
  switches). No invoice renderer is built yet.
- Values entered are preserved when a save fails; the Save button is
disabled while saving to prevent duplicate submissions.
