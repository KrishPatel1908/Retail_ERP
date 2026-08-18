import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/features/company_settings/services/company_banner_storage.dart';
import 'package:retail_erp/features/company_settings/services/company_logo_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('company_banner_test');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<File> writeImage(String name, {int sizeBytes = 100}) async {
    final file = File('${tempDir.path}/$name');
    await file.writeAsBytes(List.filled(sizeBytes, 0));
    return file;
  }

  CompanyBannerStorage storageWithTarget(Directory target) {
    return CompanyBannerStorage(directoryProvider: () async => target);
  }

  test('stores a banner and retrieves its path', () async {
    final target = Directory('${tempDir.path}/support');
    await target.create();
    final storage = storageWithTarget(target);
    final source = await writeImage('cover.png');

    final stored = await storage.store(source);

    expect(stored, '${target.path}/company_banner.png');
    expect(await File(stored).exists(), isTrue);

    final retrieved = await storage.getStoredBannerPath();
    expect(retrieved, stored);
  });

  test('rejects banner file larger than 5 MB', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage(
      'big_banner.png',
      sizeBytes: CompanyBannerStorage.maxBytes + 1,
    );

    await expectLater(
      storage.store(source),
      throwsA(
        isA<CompanyLogoException>().having(
          (e) => e.message,
          'message',
          contains('5 MB'),
        ),
      ),
    );
  });

  test('delete removes stored banner', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage('cover.jpg');
    final stored = await storage.store(source);

    expect(await File(stored).exists(), isTrue);
    await storage.delete();
    expect(await File(stored).exists(), isFalse);
    expect(await storage.getStoredBannerPath(), isNull);
  });
}
