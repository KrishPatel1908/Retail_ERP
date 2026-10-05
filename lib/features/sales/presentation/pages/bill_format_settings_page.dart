import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/content_panel.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../company_settings/data/repositories/company_settings_repository.dart';
import '../../../company_settings/domain/entities/company_settings.dart';
import '../../data/repositories/bill_format_repository.dart';
import '../../domain/entities/bill_format_settings.dart';
import '../widgets/receipt_view.dart';

/// Bill Format Settings module allowing store owners to choose between predefined
/// thermal receipt templates (Standard 80mm, Detailed GST 80mm, Compact 58mm, Simple 80mm),
/// customize header branding, line item fields, footer text, and preview changes in real time.
class BillFormatSettingsPage extends StatefulWidget {
  const BillFormatSettingsPage({super.key});

  @override
  State<BillFormatSettingsPage> createState() => _BillFormatSettingsPageState();
}

class _BillFormatSettingsPageState extends State<BillFormatSettingsPage> {
  final BillFormatRepository _formatRepo = BillFormatRepository.instance;
  final CompanySettingsRepository _companyRepo = CompanySettingsRepository();

  BillFormatSettings _settings = const BillFormatSettings();
  CompanySettings? _companySettings;
  bool _loading = true;
  bool _saving = false;

  late final TextEditingController _footerController;

  @override
  void initState() {
    super.initState();
    _footerController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _footerController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final settings = await _formatRepo.loadSettings();
      final company = await _companyRepo.getOrCreate();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _companySettings = company;
        _footerController.text = settings.footerMessage;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _saving = true);
    final updated = _settings.copyWith(
      footerMessage: _footerController.text.trim(),
    );
    await _formatRepo.saveSettings(updated);
    if (!mounted) return;
    setState(() {
      _settings = updated;
      _saving = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bill format "${updated.templateType.label}" saved successfully.'),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _selectTemplate(BillTemplateType template) {
    setState(() {
      _settings = _settings.copyWith(
        templateType: template,
        paperSize: template.defaultPaperSize,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final comp = _companySettings;
    final compAddress = [
      comp?.addressLine1,
      comp?.addressLine2,
      comp?.city,
      if (comp?.pincode != null) '- ${comp!.pincode}',
    ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

    // Sample preview items
    final sampleItems = const [
      ReceiptLineItem(
        productName: 'Parle-G 10',
        variantName: '100g',
        barcode: '8901234567890',
        hsnCode: '1905',
        quantity: 2,
        unitPricePaise: 1000,
        discountPaise: 0,
        lineTotalPaise: 2000,
      ),
      ReceiptLineItem(
        productName: 'Amul Butter',
        variantName: '500g',
        barcode: '8901234567891',
        hsnCode: '0405',
        quantity: 1,
        unitPricePaise: 27500,
        discountPaise: 2500,
        lineTotalPaise: 25000,
      ),
      ReceiptLineItem(
        productName: 'Organic Green Tea',
        variantName: 'Pack of 25',
        barcode: '8901234567892',
        hsnCode: '0902',
        quantity: 1,
        unitPricePaise: 18000,
        discountPaise: 0,
        lineTotalPaise: 18000,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Page Header
          PageHeader(
            title: 'Bill Format Settings',
            description: 'Choose from predefined receipt templates, customize fields, and preview live retail receipts.',
            actions: [
              FilledButton.icon(
                onPressed: _saving ? null : _saveSettings,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Use This Format'),
              ),
            ],
          ),

          // Main split layout: Left = Configuration, Right = Live Preview
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Configuration Form
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 12, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Predefined Templates Section
                        ContentPanel(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Available Templates',
                                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Active: ${_settings.templateType.label}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Select a receipt format tailored to your billing workflow:',
                                style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 14),

                              // Template Cards Grid
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 2.1,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildTemplateCard(
                                    type: BillTemplateType.standard80,
                                    icon: Icons.receipt_rounded,
                                    badge: '80mm',
                                  ),
                                  _buildTemplateCard(
                                    type: BillTemplateType.detailedGst80,
                                    icon: Icons.account_balance_rounded,
                                    badge: '80mm GST',
                                  ),
                                  _buildTemplateCard(
                                    type: BillTemplateType.compact58,
                                    icon: Icons.receipt_long_rounded,
                                    badge: '58mm',
                                  ),
                                  _buildTemplateCard(
                                    type: BillTemplateType.simple80,
                                    icon: Icons.flash_on_rounded,
                                    badge: '80mm Fast',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Header Branding Section
                        ContentPanel(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Header Customization',
                                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              _buildSwitch(
                                'Show Store Logo / Icon',
                                'Include company store logo icon at the top of the receipt.',
                                _settings.showLogo,
                                (val) => setState(() => _settings = _settings.copyWith(showLogo: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Company Name',
                                comp?.companyName ?? 'Display business name',
                                _settings.showCompanyName,
                                (val) => setState(() => _settings = _settings.copyWith(showCompanyName: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Store Address',
                                compAddress.isNotEmpty ? compAddress : 'Include store location address',
                                _settings.showAddress,
                                (val) => setState(() => _settings = _settings.copyWith(showAddress: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Phone Number',
                                comp?.mobile ?? 'Include support / contact number',
                                _settings.showPhone,
                                (val) => setState(() => _settings = _settings.copyWith(showPhone: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Email Address',
                                comp?.email ?? 'Include store email address',
                                _settings.showEmail,
                                (val) => setState(() => _settings = _settings.copyWith(showEmail: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show GSTIN',
                                comp?.gstNumber ?? 'Display business GSTIN for tax invoices',
                                _settings.showGstin,
                                (val) => setState(() => _settings = _settings.copyWith(showGstin: val)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Receipt Details Section
                        ContentPanel(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Item Details & Breakdown',
                                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              _buildSwitch(
                                'Show Customer Information',
                                'Show customer name and contact or Walk-in Customer',
                                _settings.showCustomer,
                                (val) => setState(() => _settings = _settings.copyWith(showCustomer: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show HSN Code',
                                'Show HSN code beneath each product item line',
                                _settings.showHsn,
                                (val) => setState(() => _settings = _settings.copyWith(showHsn: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Barcode',
                                'Show barcode string beneath item names',
                                _settings.showBarcode,
                                (val) => setState(() => _settings = _settings.copyWith(showBarcode: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Discount',
                                'Show item line discounts and total bill discount',
                                _settings.showDiscount,
                                (val) => setState(() => _settings = _settings.copyWith(showDiscount: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Tax Breakdown (CGST / SGST)',
                                'Show split tax amounts on the receipt',
                                _settings.showTaxBreakdown,
                                (val) => setState(() => _settings = _settings.copyWith(showTaxBreakdown: val)),
                              ),
                              const Divider(height: 1),
                              _buildSwitch(
                                'Show Payment & Tender Details',
                                'Show payment mode, amount paid, and change/balance',
                                _settings.showPaymentDetails,
                                (val) => setState(() => _settings = _settings.copyWith(showPaymentDetails: val)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Footer Text
                        ContentPanel(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Receipt Footer Message',
                                style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Custom thank you or visit again message displayed at the bottom of the bill:',
                                style: textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _footerController,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                  hintText: 'e.g. Thank you for shopping with us! Visit again.',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    _settings = _settings.copyWith(footerMessage: text);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Live Preview Canvas
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 8, 24, 24),
                    decoration: BoxDecoration(
                      color: AppTheme.hover,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            border: Border(bottom: BorderSide(color: AppTheme.border)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.preview_rounded, size: 18, color: AppTheme.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Live Preview: ${_settings.templateType.label}',
                                  style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: _saving ? null : _saveSettings,
                                icon: const Icon(Icons.check_rounded, size: 16),
                                label: const Text('Use This Format'),
                                style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: Center(
                              child: ReceiptView(
                                saleNumber: 'SAL-000008',
                                saleDate: DateTime.now(),
                                customerName: 'Ramesh Patel',
                                customerPhone: '+91 98765 43210',
                                companyName: comp?.companyName ?? 'RETAIL STORE ERP',
                                companyAddress: compAddress.isNotEmpty ? compAddress : '12 Market Complex, Ahmedabad, Gujarat',
                                companyPhone: comp?.mobile ?? '+91 98250 12345',
                                companyEmail: comp?.email ?? 'contact@retailerp.com',
                                companyGstin: comp?.gstNumber ?? '24AAACC1206D1ZM',
                                items: sampleItems,
                                subtotalPaise: 47500,
                                discountPaise: 2500,
                                taxPaise: 4050,
                                grandTotalPaise: 49050,
                                paidAmountPaise: 50000,
                                changeAmountPaise: 950,
                                balanceAmountPaise: 0,
                                paymentMethod: 'Cash',
                                paymentStatusLabel: 'Paid',
                                formatSettings: _settings,
                                currencySymbol: comp?.currencySymbol ?? '₹',
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTemplateCard({
    required BillTemplateType type,
    required IconData icon,
    required String badge,
  }) {
    final isSelected = _settings.templateType == type;

    return InkWell(
      onTap: () => _selectTemplate(type),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: isSelected ? AppTheme.primary : AppTheme.textSecondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.hover,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              type.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11.5, color: AppTheme.textSecondary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        dense: true,
      ),
    );
  }
}
