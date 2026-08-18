import '../data/repositories/company_settings_repository.dart';
import '../domain/company_settings_exceptions.dart';
import '../domain/entities/company_settings.dart';
import '../domain/entities/company_settings_draft.dart';
import 'company_settings_validator.dart';

/// Application layer for the company configuration.
///
/// This is the central access point future modules (product master,
/// purchase, sales/POS, invoices, reports, GST reports) should use instead of
/// touching the database. It:
///
/// - treats the configuration as a singleton (one row, id `1`);
/// - caches the loaded configuration process-wide so unrelated pages never
///   repeat the database query (requirement: no unnecessary lookups);
/// - re-validates drafts before saving (defense in depth — the UI validates
///   first) and refreshes the cache after a successful save.
///
/// The cache is shared across instances (singleton-style); call
/// [invalidateCache] after schema changes or in tests that swap the database.
class CompanySettingsService {
  CompanySettingsService({CompanySettingsRepository? repository})
    : _repository = repository ?? CompanySettingsRepository();

  final CompanySettingsRepository _repository;

  /// Process-wide cached configuration; `null` until first loaded.
  static CompanySettings? _cache;

  /// The currently cached configuration, or `null` when nothing has been
  /// loaded yet in this process.
  static CompanySettings? get cached => _cache;

  /// Clears the shared cache (e.g. after a database reset in tests).
  static void invalidateCache() => _cache = null;

  /// Loads the current company configuration, using the shared cache when
  /// available. Creates the default row on first ever access.
  Future<CompanySettings> getSettings() async {
    final cached = _cache;
    if (cached != null) return cached;
    final settings = await _repository.getOrCreate();
    _cache = settings;
    return settings;
  }

  /// Validates and persists [draft], then updates the shared cache.
  ///
  /// Throws [CompanySettingsValidationException] when the draft is invalid
  /// (the UI validates first, so this only fires when a caller bypassed it).
  /// All other failures surface as [AppDatabaseException] from the repository.
  Future<CompanySettings> save(CompanySettingsDraft draft) async {
    final errors = CompanySettingsValidator.validate(draft);
    final hasErrors = errors.values.any((error) => error != null);
    if (hasErrors) {
      throw CompanySettingsValidationException(errors);
    }
    final saved = await _repository.save(draft);
    _cache = saved;
    return saved;
  }
}
