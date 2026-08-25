import 'package:flutter/material.dart';

import '../../../../core/navigation/app_page.dart';

/// Root page for the Purchase module.
///
/// Manages its own internal sub-navigation: Purchase Entry, Purchase History,
/// and Purchase Returns — similar to how the shell handles module routing.
class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  AppPage _currentPage = AppPage.purchaseHistory;

  void _navigateTo(AppPage page) {
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) {
    return _PurchaseScope(
      onNavigate: _navigateTo,
      child: switch (_currentPage) {
        AppPage.purchaseEntry => _PurchaseEntryWrapper(
          onBack: () => _navigateTo(AppPage.purchaseHistory),
        ),
        AppPage.purchaseReturns => _PurchaseReturnsWrapper(
          onBack: () => _navigateTo(AppPage.purchaseHistory),
        ),
        _ => _PurchaseHistoryWrapper(
          onNewPurchase: () => _navigateTo(AppPage.purchaseEntry),
          onNewReturn: () => _navigateTo(AppPage.purchaseReturns),
        ),
      },
    );
  }
}

/// InheritedNotifier that lets child widgets access navigation callbacks.
class _PurchaseScope extends InheritedWidget {
  const _PurchaseScope({
    required this.onNavigate,
    required super.child,
  });

  final ValueChanged<AppPage> onNavigate;

  @override
  bool updateShouldNotify(_PurchaseScope oldWidget) =>
      onNavigate != oldWidget.onNavigate;
}

/// Wraps the Purchase History page with a callback to create new purchase.
class _PurchaseHistoryWrapper extends StatelessWidget {
  const _PurchaseHistoryWrapper({
    required this.onNewPurchase,
    required this.onNewReturn,
  });

  final VoidCallback onNewPurchase;
  final VoidCallback onNewReturn;

  @override
  Widget build(BuildContext context) {
    // Will be replaced by the actual PurchaseListPage
    return const _PurchaseHistoryPlaceholder();
  }
}

/// Wraps the Purchase Entry page.
class _PurchaseEntryWrapper extends StatelessWidget {
  const _PurchaseEntryWrapper({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Will be replaced by the actual CreatePurchasePage
    return const _PurchaseEntryPlaceholder();
  }
}

/// Wraps the Purchase Returns page.
class _PurchaseReturnsWrapper extends StatelessWidget {
  const _PurchaseReturnsWrapper({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    // Will be replaced by the actual PurchaseReturnsPage
    return const _PurchaseReturnsPlaceholder();
  }
}

// Placeholder widgets - these will be replaced by actual implementations
class _PurchaseHistoryPlaceholder extends StatelessWidget {
  const _PurchaseHistoryPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Purchase History'));
}

class _PurchaseEntryPlaceholder extends StatelessWidget {
  const _PurchaseEntryPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Purchase Entry'));
}

class _PurchaseReturnsPlaceholder extends StatelessWidget {
  const _PurchaseReturnsPlaceholder();
  @override
  Widget build(BuildContext context) => const Center(child: Text('Purchase Returns'));
}
