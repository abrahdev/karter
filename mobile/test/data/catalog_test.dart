import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/services/catalog_repository.dart';
import 'package:mobile/data/services/catalog_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tmp;
  late CatalogService service;
  late CatalogRepository repo;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('catalog_test');
    service = CatalogService(documentsDirectory: tmp);
    repo = CatalogRepository(service);
    await service.catalogFile();
  });

  tearDown(() async {
    service.dispose();
    await tmp.delete(recursive: true);
  });

  test('seeds catalog from bundled asset with valid metadata', () async {
    final version = await service.catalogVersion();
    expect(version, isNotNull);
    expect(version, isNotEmpty);
  });

  test('findBestMatch picks year-specific generation over base', () async {
    final r =
        await repo.findBestMatch(make: 'Toyota', model: 'Corolla', year: 2019);
    expect(r, isNotNull);
    expect(r!.entry.meta.generation, 'E210');
    expect(r.items.any((i) => i.id == 'oil-change'), isTrue);
    expect(r.items.any((i) => i.id == 'hybrid-battery-filter'), isTrue);
  });

  test('findBestMatch falls back to base template outside year range',
      () async {
    final r =
        await repo.findBestMatch(make: 'Toyota', model: 'Corolla', year: 2010);
    expect(r, isNotNull);
    expect(r!.entry.meta.generation, 'All');
  });

  test('findBestMatch returns null when no match', () async {
    final r = await repo.findBestMatch(
        make: 'Tesla', model: 'Model 3', year: 2020);
    expect(r, isNull);
  });

  test('vehicle DTCs inherit general codes plus per-vehicle diffs', () async {
    final r =
        await repo.findBestMatch(make: 'Toyota', model: 'Corolla', year: 2019);
    expect(r!.dtcs.length, greaterThan(10000));
    final p0171 = r.dtcs.firstWhere((d) => d.code == 'P0171');
    expect(p0171.descI18nKey, 'dtc_p0171');
    final p1100 = r.dtcs.firstWhere((d) => d.code == 'P1100');
    expect(p1100.scope, 'manufacturer');
  });

  test('motorcycle inherits full general set with no diffs', () async {
    final r = await repo.findBestMatch(
        make: 'Kawasaki', model: 'Ninja 400', year: 2020);
    expect(r!.dtcs.length, greaterThan(10000));
    final general = await repo.resolveGeneralDtcs();
    expect(r.dtcs.length, general.length);
  });

  test('resolveGeneralDtcs loads base OBD codes', () async {
    final dtcs = await repo.resolveGeneralDtcs();
    expect(dtcs.length, greaterThan(10000));
    final p0171 = dtcs.firstWhere((d) => d.code == 'P0171');
    expect(p0171.descI18nKey, 'dtc_p0171');
    expect(p0171.scope, 'standard');
  });

  test('loadIndex exposes vehicles including base templates', () async {
    final index = await repo.loadIndex();
    expect(index.templates.length, greaterThan(80));
    expect(index.templates.any((e) => e.meta.make == 'Toyota'), isTrue);
  });
}
