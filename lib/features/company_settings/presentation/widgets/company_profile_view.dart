import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../shared/widgets/breadcrumbs.dart';
import '../../domain/entities/company_settings.dart';

/// LinkedIn / Instagram style Profile View for the Company Settings.
///
/// Displays a hero banner with the company logo, business identity, verified
/// GST badges, and structured overview cards for address, tax, financial, and
/// bank details.
class CompanyProfileView extends StatelessWidget {
  const CompanyProfileView({
    super.key,
    required this.settings,
    required this.onEdit,
    this.onUploadLogo,
    this.bannerPath,
    this.onUploadBanner,
    this.onRemoveBanner,
  });

  final CompanySettings settings;
  final VoidCallback onEdit;
  final VoidCallback? onUploadLogo;
  final String? bannerPath;
  final VoidCallback? onUploadBanner;
  final VoidCallback? onRemoveBanner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 36),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Breadcrumbs(
                      items: ['Master Entry', 'Company Settings'],
                    ),
                    FilledButton.icon(
                      key: const ValueKey('company-profile-edit-button'),
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, size: 16),
                      label: const Text('Edit Profile'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _HeroProfileCard(
                  settings: settings,
                  onEdit: onEdit,
                  onUploadLogo: onUploadLogo,
                  bannerPath: bannerPath,
                  onUploadBanner: onUploadBanner,
                  onRemoveBanner: onRemoveBanner,
                ),
                const SizedBox(height: 24),
                _ProfileContentGrid(settings: settings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroProfileCard extends StatelessWidget {
  const _HeroProfileCard({
    required this.settings,
    required this.onEdit,
    this.onUploadLogo,
    this.bannerPath,
    this.onUploadBanner,
    this.onRemoveBanner,
  });

  final CompanySettings settings;
  final VoidCallback onEdit;
  final VoidCallback? onUploadLogo;
  final String? bannerPath;
  final VoidCallback? onUploadBanner;
  final VoidCallback? onRemoveBanner;

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'CO';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasLogo =
        settings.logoPath != null &&
        settings.logoPath!.isNotEmpty &&
        File(settings.logoPath!).existsSync();

    final hasBanner =
        bannerPath != null &&
        bannerPath!.isNotEmpty &&
        File(bannerPath!).existsSync();

    final locationParts = [
      if (settings.city != null && settings.city!.isNotEmpty) settings.city,
      if (settings.state != null && settings.state!.isNotEmpty) settings.state,
      if (settings.country != null && settings.country!.isNotEmpty)
        settings.country,
    ];
    final locationText = locationParts.join(', ');

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Banner cover area with rounded top corners.
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (hasBanner) ...[
                        Image.file(
                          File(bannerPath!),
                          key: ValueKey(
                            '${bannerPath}_${File(bannerPath!).existsSync() ? File(bannerPath!).lastModifiedSync().millisecondsSinceEpoch : 0}',
                          ),
                          fit: BoxFit.cover,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.85),
                                colorScheme.primaryContainer,
                                colorScheme.tertiaryContainer,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 180,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                      // Cover photo actions on top-right.
                      if (onUploadBanner != null)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilledButton.tonalIcon(
                                key: const ValueKey(
                                  'company-profile-banner-upload',
                                ),
                                onPressed: onUploadBanner,
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.black.withValues(
                                    alpha: 0.45,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 15,
                                ),
                                label: Text(
                                  hasBanner ? 'Change Cover' : 'Add Cover',
                                ),
                              ),
                              if (hasBanner && onRemoveBanner != null) ...[
                                const SizedBox(width: 8),
                                IconButton.filledTonal(
                                  key: const ValueKey(
                                    'company-profile-banner-remove',
                                  ),
                                  onPressed: onRemoveBanner,
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.45,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 16,
                                  ),
                                  tooltip: 'Remove Cover Photo',
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Profile Details Section (below the banner).
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 56, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            settings.companyName.isNotEmpty
                                ? settings.companyName
                                : 'Company Name',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        if (settings.gstRegistered) ...[
                          const SizedBox(width: 8),
                          Tooltip(
                            message: 'GST Registered Business',
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.verified_rounded,
                                size: 18,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Badges row: Business Type, GST status, Location.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _BadgePill(
                          icon: Icons.business_center_outlined,
                          label: settings.businessType.label,
                          backgroundColor: colorScheme.secondaryContainer
                              .withValues(alpha: 0.5),
                          textColor: colorScheme.onSecondaryContainer,
                        ),
                        if (settings.gstRegistered &&
                            settings.gstNumber != null &&
                            settings.gstNumber!.isNotEmpty)
                          _BadgePill(
                            icon: Icons.receipt_long_outlined,
                            label: 'GSTIN: ${settings.gstNumber}',
                            backgroundColor: Colors.green.withValues(
                              alpha: 0.12,
                            ),
                            textColor: Colors.green.shade800,
                          ),
                        if (locationText.isNotEmpty)
                          _BadgePill(
                            icon: Icons.location_on_outlined,
                            label: locationText,
                            backgroundColor: colorScheme.surfaceContainerHigh,
                            textColor: colorScheme.onSurfaceVariant,
                          ),
                      ],
                    ),
                    if ((settings.mobile != null &&
                            settings.mobile!.isNotEmpty) ||
                        (settings.email != null &&
                            settings.email!.isNotEmpty) ||
                        (settings.website != null &&
                            settings.website!.isNotEmpty)) ...[
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          if (settings.mobile != null &&
                              settings.mobile!.isNotEmpty)
                            _ContactChip(
                              icon: Icons.phone_outlined,
                              text: settings.mobile!,
                            ),
                          if (settings.email != null &&
                              settings.email!.isNotEmpty)
                            _ContactChip(
                              icon: Icons.email_outlined,
                              text: settings.email!,
                            ),
                          if (settings.website != null &&
                              settings.website!.isNotEmpty)
                            _ContactChip(
                              icon: Icons.language_rounded,
                              text: settings.website!,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          // Floating Avatar overlapping the banner bottom.
          Positioned(
            left: 28,
            top: 102,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Tooltip(
                  message: onUploadLogo != null ? 'Click to change logo' : '',
                  child: InkWell(
                    onTap: onUploadLogo,
                    borderRadius: BorderRadius.circular(54),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: hasLogo
                            ? Container(
                                color: colorScheme.surface,
                                padding: const EdgeInsets.all(5),
                                child: Image.file(
                                  File(settings.logoPath!),
                                  key: ValueKey(
                                    '${settings.logoPath}_${File(settings.logoPath!).existsSync() ? File(settings.logoPath!).lastModifiedSync().millisecondsSinceEpoch : 0}',
                                  ),
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _InitialsAvatar(
                                        initials: _getInitials(
                                          settings.companyName,
                                        ),
                                      ),
                                ),
                              )
                            : _InitialsAvatar(
                                initials: _getInitials(settings.companyName),
                              ),
                      ),
                    ),
                  ),
                ),
                if (onUploadLogo != null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: colorScheme.primary,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        onTap: onUploadLogo,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 15,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProfileContentGrid extends StatelessWidget {
  const _ProfileContentGrid({required this.settings});

  final CompanySettings settings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        if (isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Company & Tax Identity + Tax & Invoicing
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBusinessCard(context),
                        const SizedBox(height: 20),
                        _buildTaxAndBillingCard(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Right Column: Business Address + Financial Settings
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAddressCard(context),
                        const SizedBox(height: 20),
                        _buildFinancialCard(context),
                      ],
                    ),
                  ),
                ],
              ),
              if (_hasBankDetails) ...[
                const SizedBox(height: 20),
                _buildBankCard(context),
              ],
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBusinessCard(context),
              const SizedBox(height: 20),
              _buildAddressCard(context),
              const SizedBox(height: 20),
              _buildTaxAndBillingCard(context),
              const SizedBox(height: 20),
              _buildFinancialCard(context),
              if (_hasBankDetails) ...[
                const SizedBox(height: 20),
                _buildBankCard(context),
              ],
            ],
          );
        }
      },
    );
  }

  bool get _hasBankDetails =>
      (settings.bankName != null && settings.bankName!.isNotEmpty) ||
      (settings.bankAccountNumber != null &&
          settings.bankAccountNumber!.isNotEmpty) ||
      (settings.upiId != null && settings.upiId!.isNotEmpty);

  Widget _buildBusinessCard(BuildContext context) {
    return _InfoCard(
      title: 'Company & Tax Identity',
      icon: Icons.badge_outlined,
      children: [
        _InfoRow(label: 'Business Name', value: settings.companyName),
        _InfoRow(label: 'Business Type', value: settings.businessType.label),
        _InfoRow(
          label: 'GST Registered',
          value: settings.gstRegistered ? 'Yes' : 'No',
        ),
        if (settings.gstRegistered &&
            settings.gstNumber != null &&
            settings.gstNumber!.isNotEmpty)
          _InfoRow(label: 'GSTIN', value: settings.gstNumber!),
        if (settings.panNumber != null && settings.panNumber!.isNotEmpty)
          _InfoRow(label: 'PAN', value: settings.panNumber!),
        if (settings.cin != null && settings.cin!.isNotEmpty)
          _InfoRow(label: 'CIN', value: settings.cin!),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context) {
    return _InfoCard(
      title: 'Business Address',
      icon: Icons.location_on_outlined,
      children: [
        if (settings.addressLine1 != null && settings.addressLine1!.isNotEmpty)
          _InfoRow(label: 'Address 1', value: settings.addressLine1!),
        if (settings.addressLine2 != null && settings.addressLine2!.isNotEmpty)
          _InfoRow(label: 'Address 2', value: settings.addressLine2!),
        if (settings.city != null && settings.city!.isNotEmpty)
          _InfoRow(label: 'City', value: settings.city!),
        if (settings.state != null && settings.state!.isNotEmpty)
          _InfoRow(label: 'State', value: settings.state!),
        if (settings.pincode != null && settings.pincode!.isNotEmpty)
          _InfoRow(label: 'Pincode', value: settings.pincode!),
        if (settings.country != null && settings.country!.isNotEmpty)
          _InfoRow(label: 'Country', value: settings.country!),
      ],
    );
  }

  Widget _buildTaxAndBillingCard(BuildContext context) {
    return _InfoCard(
      title: 'Tax & Invoicing',
      icon: Icons.receipt_long_outlined,
      children: [
        _InfoRow(
          label: 'Default Tax Treatment',
          value: settings.defaultTaxType.label,
        ),
        _InfoRow(label: 'Invoice Prefix', value: settings.invoicePrefix),
        _InfoRow(
          label: 'Starting Invoice #',
          value: settings.invoiceStartNumber.toString(),
        ),
      ],
    );
  }

  Widget _buildFinancialCard(BuildContext context) {
    final monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final monthName =
        (settings.financialYearStartMonth >= 1 &&
            settings.financialYearStartMonth <= 12)
        ? monthNames[settings.financialYearStartMonth]
        : 'Month ${settings.financialYearStartMonth}';

    return _InfoCard(
      title: 'Financial Settings',
      icon: Icons.account_balance_wallet_outlined,
      children: [
        _InfoRow(label: 'Financial Year Start', value: monthName),
        _InfoRow(
          label: 'Currency',
          value: '${settings.currencyCode} (${settings.currencySymbol})',
        ),
        _InfoRow(
          label: 'Decimal Places',
          value: settings.decimalPlaces.toString(),
        ),
      ],
    );
  }

  Widget _buildBankCard(BuildContext context) {
    return _InfoCard(
      title: 'Bank & Settlement Details',
      icon: Icons.account_balance_outlined,
      children: [
        if (settings.bankName != null && settings.bankName!.isNotEmpty)
          _InfoRow(label: 'Bank Name', value: settings.bankName!),
        if (settings.bankAccountName != null &&
            settings.bankAccountName!.isNotEmpty)
          _InfoRow(label: 'Account Name', value: settings.bankAccountName!),
        if (settings.bankAccountNumber != null &&
            settings.bankAccountNumber!.isNotEmpty)
          _InfoRow(label: 'Account Number', value: settings.bankAccountNumber!),
        if (settings.bankIfsc != null && settings.bankIfsc!.isNotEmpty)
          _InfoRow(label: 'IFSC Code', value: settings.bankIfsc!),
        if (settings.bankBranch != null && settings.bankBranch!.isNotEmpty)
          _InfoRow(label: 'Branch', value: settings.bankBranch!),
        if (settings.upiId != null && settings.upiId!.isNotEmpty)
          _InfoRow(label: 'UPI ID', value: settings.upiId!),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
