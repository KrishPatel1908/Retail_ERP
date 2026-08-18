# Retail ERP

Desktop-first shell for a Retail ERP application, built with Flutter and
Material 3. Navigation only — no database, state-management package, or
business logic yet.

## Shell

- **Top bar** — brand, sidebar collapse toggle, logged-in user placeholder,
  settings action placeholder.
- **Collapsible left sidebar** — expanded shows icon + label rows; collapsed
  shows an icon-only rail with tooltips. "Master Entry" is an expandable group
  (popup menu when the sidebar is collapsed).
- **Content area** — displays the selected page title (navigation only).
- **Status bar** — status indicator, current page and app version.

Responsive: the sidebar auto-collapses below 760 px window width; the user
name/role text hides below 900 px. Light and dark themes follow the system.

## Modules

- **Category** — list page (breadcrumb, search, Add button, empty state) and a
  dedicated Create Category page reached through content-area navigation.
- **Company Settings** — single-company configuration page (identity,
  address, logo, tax/billing, financial, bank and invoice settings) with
  cached access for future invoice, POS, purchase, sales, GST and reporting
  modules.

## Folder structure

```
lib/
  main.dart                     # Entry point
  app/
    retail_erp_app.dart         # Root MaterialApp
    theme/app_theme.dart        # Material 3 light/dark themes
  core/
    constants/app_constants.dart
    navigation/                 # Page enum, nav tree models, nav data
  features/
    shell/                      # Desktop shell feature
      shell_page.dart           # Composes top bar, sidebar, content, status bar
      widgets/                  # Reusable shell widgets
```

## Run

```sh
flutter run -d macos   # or -d windows, -d linux
```

## Test

```sh
flutter analyze && flutter test
```
