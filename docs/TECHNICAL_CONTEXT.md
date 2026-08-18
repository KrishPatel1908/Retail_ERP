# TECHNICAL_CONTEXT.md

# Technical Context

## Project

Retail ERP

Platform

Flutter Desktop

Supported Platforms

- Windows
- macOS

Architecture

- Feature First
- Clean Architecture
- Repository Pattern

Database

- SQLite
- Drift ORM

Language

- Dart

UI

- Material 3

---

# Technology Stack

Frontend

- Flutter

Programming Language

- Dart

Database

- SQLite

ORM

- Drift

Architecture

- Feature First
- Clean Architecture

Version Control

- Git
- GitHub

---

# Project Structure

lib/

app/

core/

shared/

features/

main.dart

Every folder has a specific responsibility.

---

# app/

Contains application initialization.

Responsibilities

- MaterialApp
- Theme
- Routing
- Global Configuration

---

# core/

Contains reusable infrastructure.

Examples

- Constants
- Navigation
- Database
- Exceptions
- Utilities

Core never contains business features.

---

# shared/

Contains reusable UI components.

Examples

- AppDataTable
- Buttons
- Dialogs
- SearchField
- PageHeader
- ContentPanel
- Breadcrumbs
- DescriptionPreview

These widgets are shared across every feature.

---

# features/

Contains every business module.

Each feature is independent.

Example

features/

category/

brand/

product/

customer/

supplier/

inventory/

purchase/

sales/

Every feature follows the same architecture.

---

# Feature Structure

Example

feature/

data/

domain/

presentation/

services/

Purpose

data

Database access

Repositories

domain

Business entities

Business exceptions

presentation

UI

Pages

Widgets

services

Validation

Feature-specific services

---

# Database Layer

Database

SQLite

ORM

Drift

Architecture

UI

↓

Repository

↓

Drift

↓

SQLite

Presentation never communicates directly with Drift.

Only repositories communicate with the database.

---

# Shared Database

The application uses

One AppDatabase

One SQLite database

Singleton pattern

Only one database instance exists during runtime.

---

# Navigation

Navigation Type

Sidebar

Master Entry modules stay inside

Master Entry

Transactions stay inside

Transactions

Reports stay inside

Reports

No feature directly manipulates navigation.

---

# Theme

Material 3

Desktop First

Responsive

Light Theme

Reusable Color System

Reusable Typography

---

# State Management

Current Philosophy

Keep state local whenever possible.

Do not introduce unnecessary complexity.

Business logic remains inside repositories and services.

---

# UI Principles

Desktop First

Responsive

Clean Layout

Minimal Design

Reusable Components

Professional ERP Experience

The UI should resemble modern desktop software.

---

# Shared Components

- AppDataTable (View, Edit, Delete actions)
- PageHeader
- SearchField
- LabelledField (with Enter->Next focus traversal & auto-scroll)
- FormFocusController (global focus & validation error scroll-to-field)
- UpperCaseTextFormatter
- ContentPanel
- Breadcrumbs
- Status Badge
- Dialog Components (CustomerDetailDialog, SupplierDetailDialog)

Every module should reuse these widgets.

---

# Validation

Validation belongs inside

services/

Never inside widgets.

Validation must be reusable.

---

# Error Handling

Every feature should handle

Validation Errors

Database Errors

Unexpected Errors

Foreign Key Errors

Duplicate Records

The application should never crash.

---

# Testing

Every module must pass

flutter analyze

flutter test

No warnings

No deprecated APIs

No RenderFlex overflow

---

# Current Completed Modules

Foundation

Completed

Desktop Shell

Navigation

Database Foundation

Responsive Layout

Master Entry

Completed

Category

Unit Master

Global UOM Conversion

Product UOM Conversion

Brand

Tax Type

Tax Category

Customer Master

Supplier Master

---

# Pending Modules

Sub Category

Warehouse Master

Company Settings

Product Master

Inventory

Purchase

Sales POS

Reports

Dashboard

Accounting

AI Assistant

---

# Git Workflow

Development

↓

Analyze

↓

Test

↓

Commit

↓

Push

Every completed feature should be committed using meaningful Conventional Commit messages.

---

# Development Philosophy

Every new module should

Reuse existing architecture

Reuse shared widgets

Reuse repository pattern

Reuse validation pattern

Reuse table components

Avoid duplicated code

Avoid breaking existing modules

Maintain consistency across the entire ERP.

## Ordered form focus

`lib/shared/utils/form_focus_controller.dart` owns form field nodes, numeric
orders, scroll keys, and first-invalid-field focus. `LabelledField`,
`LabelledDropdown`, date controls and `SwitchField` apply the numeric order
provided by that controller. This prevents responsive widget tree changes from
changing keyboard navigation.
