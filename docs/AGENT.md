# AGENT.md

You are working on a production-grade Offline Retail ERP Desktop Application.

This document defines the development rules that MUST be followed throughout the project.

Never violate these rules.

---

# Project Overview

Project Name:
Retail ERP

Platform:
Flutter Desktop

Supported OS:
- Windows
- macOS

Database:
SQLite

ORM:
Drift ORM

Architecture:
Feature First + Clean Architecture

Purpose:

Develop a modern, production-ready Retail ERP that works completely offline and is scalable enough for future cloud synchronization.

---

# Development Philosophy

This project prioritizes:

- Clean Code
- Readability
- Maintainability
- Scalability
- Reusability
- Performance
- Desktop-first User Experience

Never sacrifice architecture for short-term convenience.

---

# Coding Principles

Always follow:

- SOLID Principles
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple)
- Separation of Concerns
- Single Responsibility Principle

Avoid duplicated code.

Avoid large files.

Prefer reusable components.

---

# Folder Structure Rules

Follow Feature First Architecture.

Example

lib/

app/

core/

shared/

features/

Every feature must remain independent.

Never mix feature code.

---

# UI Rules

The application is Desktop First.

The UI should feel similar in quality to professional desktop software.

Requirements:

- Material 3
- Responsive
- Clean spacing
- Consistent typography
- Reusable widgets
- Smooth animations
- Hover states
- Keyboard-friendly

Do not redesign existing UI unless specifically requested.

---

# Shared Widgets

Whenever possible reuse:

- AppDataTable
- PageHeader
- SearchField
- ContentPanel
- LabelledField
- Breadcrumbs
- Shared Buttons
- Shared Dialogs

Never duplicate existing widgets.

---

# Navigation Rules

Navigation is sidebar based.

Master Entry modules remain inside the Master Entry section.

Do not modify navigation without approval.

---

# Database Rules

Database:

SQLite

ORM:

Drift

Never bypass repositories.

Presentation must never communicate directly with Drift.

Repository handles database operations.

Never duplicate database logic.

---

# Business Logic Rules

Business logic belongs inside:

Repository

or

Service

Never inside widgets.

Never inside UI pages.

---

# Form UX & Keyboard Navigation Rules

Forms across the ERP must strictly adhere to the global form UX standards:

- **Enter Key Focus Traversal**: Pressing Enter inside a single-line input field moves focus to the next logical editable field and places the cursor inside without submitting the form.
- **Multiline Fields**: Text areas with `maxLines > 1` (Description, Notes, Address) preserve standard Enter key newline creation.
- **Auto-Scroll to Focused Field**: Any field receiving focus automatically scrolls into view within the scroll viewport.
- **Validation Failure Focus**: Clicking Save on a form with invalid or missing fields must automatically locate the first invalid field, scroll to make it visible, focus the field, place cursor inside, and display the inline validation error message.
- **Input Restrictions**: Apply input formatters where appropriate (e.g. 10-digit numeric mobile/alternate mobile, 6-digit pincode, uppercase GSTIN/PAN formatters, decimal monetary input formatters).
- **Read-Only Record Viewing**: Record tables must provide View, Edit, and Delete actions. The View action opens a read-only detail view displaying all available fields without enabling editing.

---

# Validation Rules

Validation must be reusable.

Never duplicate validation logic.

Create dedicated validator classes.

---

# Error Handling

Application must never crash.

Always show friendly error messages.

Handle:

- Validation errors
- Database errors
- Duplicate records
- Foreign key errors
- Unexpected exceptions

---

# Code Style

Prefer:

Small classes

Small methods

Meaningful names

Readable code

Avoid magic numbers.

Avoid deeply nested code.

---

# Naming Convention

Files

snake_case

Classes

PascalCase

Variables

camelCase

Constants

UPPER_CASE only when appropriate.

---

# State Management

Keep state local whenever possible.

Do not introduce unnecessary complexity.

Only use shared state when required.

---

# Database Design Rules

Normalize tables.

Avoid duplicate data.

Use foreign keys.

Use integer primary keys.

Design for future scalability.

Never redesign existing approved schema without approval.

---

# Master Entry Modules

Current modules

- Category
- Unit Master
- Global UOM Conversion
- Product UOM Conversion
- Brand
- Tax Type
- Tax Category
- HSN Master

Future modules

- Sub Category
- Warehouse
- Customer
- Supplier
- Company Settings
- Product Master

---

# Product UOM Priority

Always follow:

Product UOM

↓

Global UOM

↓

No Conversion Found

Never change this priority.

---

# Testing Rules

Every completed module must pass:

flutter analyze

flutter test

No warnings.

No deprecated APIs.

No RenderFlex overflow.

---

# Performance Rules

Avoid unnecessary rebuilds.

Reuse widgets.

Lazy load data when appropriate.

Keep scrolling smooth.

Desktop performance is important.

---

# Git Rules

Use meaningful commit messages.

Prefer Conventional Commits.

Example

feat:

fix:

refactor:

docs:

test:

---

# Documentation Rules

Whenever a new module is completed:

Update:

PROJECT_CONTEXT.md

FUNCTIONS.md

DATABASE.md

if required.

Documentation should always match the codebase.

---

# AI Rules

When modifying code:

Understand existing architecture first.

Reuse existing patterns.

Never rewrite completed modules unnecessarily.

Do not introduce breaking changes.

Keep implementation consistent with previous modules.

If a change affects another module, explain the impact before implementing.

---

# Final Goal

Build a production-grade Offline Retail ERP that is:

- Fast
- Maintainable
- Modular
- Scalable
- Easy to extend
- Easy to understand
- Suitable for real businesses

Every implementation should move the project closer to this goal.

## Form keyboard standard

Customer and Supplier forms use `FormFocusController` with
`FocusTraversalGroup(OrderedTraversalPolicy)` and numeric focus orders. New
desktop ERP forms should use this utility so Tab/Shift+Tab and Enter on a
single-line input follow the documented field order; multiline inputs retain
their normal newline behavior.
