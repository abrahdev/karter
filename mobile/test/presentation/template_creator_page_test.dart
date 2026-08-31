import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/models/template_meta.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/template_creator_page.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

TemplateIndex fakeIndex() {
  return TemplateIndex(
    templates: [
      TemplateIndexEntry(
        id: 'toyota-corolla',
        path: 'data/toyota/corolla/base.json',
        meta: TemplateMeta(
          make: 'Toyota',
          model: 'Corolla',
          generation: 'E210',
          years: const [2019, 2024],
          engine: EngineMeta(
            code: 'M20A-FKS',
            fuel: 'gasoline',
            powertrain: 'hybrid',
            displacementCc: 1987,
            powerHp: 169,
          ),
          author: 'abrahdev',
          version: '1.0.0',
        ),
        itemCount: 1,
        extendsPaths: const ['_base/car-common.json'],
      ),
    ],
  );
}

class _FakeResolver extends TemplateResolver {
  @override
  Future<InheritedContent> resolveExtendsChain(
    List<String> extendsPaths, {
    String? baseUrl,
  }) async {
    return InheritedContent(
      parts: [
        InheritedPart(
          origin: '_base/car-common.json',
          part: ResolvedPart(
            id: 'brake-pad-set',
            name: 'Brake pads (set)',
            oemNumber: '90915-YZZE3',
            quantity: 1,
            unit: 'set',
          ),
        ),
      ],
      items: [
        InheritedItem(
          origin: '_base/car-common.json',
          item: ResolvedItem(
            id: 'brake-pads',
            label: 'Brake pads',
            intervalKm: 30000,
            intervalMonths: 12,
          ),
        ),
      ],
    );
  }
}

class _FakeTemplateSourceNotifier extends TemplateSourceNotifier {
  @override
  TemplateSourceConfig build() =>
      const TemplateSourceConfig(enabled: true, repoUrl: 'https://example.com');
}

Future<void> pumpCreator(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        templateSourceProvider
            .overrideWith(_FakeTemplateSourceNotifier.new),
        onlineTemplateBaseUrlProvider.overrideWith(
          (ref) async => 'https://example.com/templates',
        ),
        onlineTemplateIndexProvider
            .overrideWith((ref) async => Future.value(fakeIndex())),
        templateResolverProvider.overrideWithValue(_FakeResolver()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TemplateCreatorPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('creator: shows the online repo URL block', (tester) async {
    await pumpCreator(tester);

    expect(find.text('https://example.com'), findsOneWidget);
  });

  testWidgets('creator: opening the fuel dropdown does not throw',
      (tester) async {
    await pumpCreator(tester);

    await tester.ensureVisible(find.text('Fuel'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fuel'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Diesel').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Diesel'), findsOneWidget);
  });

  testWidgets('creator: opening the powertrain dropdown does not throw',
      (tester) async {
    await pumpCreator(tester);

    await tester.ensureVisible(find.text('Powertrain'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Powertrain'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('creator: matching make/model computes extends and shows '
      'inherited parts/items', (tester) async {
    await pumpCreator(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Make'),
      'Toyota',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Model'),
      'Corolla',
    );
    await tester.pumpAndSettle();

    final chip = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, '_base/car-common.json'),
    );
    expect(chip.selected, isTrue);

    expect(find.text('Inherited parts (from extends)'), findsOneWidget);
    expect(find.text('Brake pads (set)'), findsOneWidget);
    expect(find.text('Inherited maintenance (from extends)'), findsOneWidget);
    expect(find.text('Brake pads'), findsOneWidget);
  });
}