import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:retail_erp/features/company_settings/services/company_logo_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('company_logo_test');
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

  CompanyLogoStorage storageWithTarget(Directory target) {
    return CompanyLogoStorage(directoryProvider: () async => target);
  }

  test('stores a supported image and returns the stored path', () async {
    final target = Directory('${tempDir.path}/support');
    await target.create();
    final storage = storageWithTarget(target);
    final source = await writeImage('logo.png');

    final stored = await storage.store(source);

    expect(stored, '${target.path}/company_logo.png');
    expect(await File(stored).exists(), isTrue);
    expect(await File(stored).readAsBytes(), await source.readAsBytes());
  });

  test('rejects unsupported file types', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage('logo.gif');

    await expectLater(
      storage.store(source),
      throwsA(isA<CompanyLogoException>()),
    );
  });

  test('rejects oversized files', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage(
      'big.png',
      sizeBytes: CompanyLogoStorage.maxBytes + 1,
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

  test('validate fails fast without copying', () async {
    final target = Directory('${tempDir.path}/support');
    await target.create();
    final storage = storageWithTarget(target);
    final source = await writeImage('logo.jpg');

    await storage.validate(source);
    expect(Directory('${target.path}/company_logo.jpg').existsSync(), isFalse);

    final bad = await writeImage('logo.txt');
    await expectLater(
      storage.validate(bad),
      throwsA(isA<CompanyLogoException>()),
    );
  });

  test('delete removes the file and tolerates missing files', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage('logo.png');
    final stored = await storage.store(source);

    await storage.delete(stored);
    expect(await File(stored).exists(), isFalse);

    // Deleting an already-missing file is a no-op.
    await storage.delete(stored);
  });

  test('extensions are matched case-insensitively', () async {
    final storage = storageWithTarget(tempDir);
    final source = await writeImage('logo.PNG');

    expect(await storage.store(source), '${tempDir.path}/company_logo.png');
  });
}
