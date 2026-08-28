import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/template_index.dart';
import 'package:mobile/data/models/template_meta.dart';
import 'package:mobile/data/services/template_resolver.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/template_detail_page.dart';
import 'package:mobile/presentation/pages/template_list_page.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';

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

TemplateResolution fakeResolution() {
  return TemplateResolution(
    entry: fakeIndex().templates.first,
    items: [
      ResolvedItem(
        id: 'oil-change',
        label: 'Oil change',
        i18nKey: 'seed_interval_oil_change',
        intervalKm: 15000,
        intervalMonths: 12,
        description: 'Replace oil',
        parts: const {'oil-filter': 1},
      ),
    ],
    parts: [
      ResolvedPart(
        id: 'oil-filter',
        name: 'Oil filter',
        oemNumber: '90915-YZZE3',
        quantity: 1,
        unit: 'unit',
      ),
    ],
    dtcs: [
      ResolvedDtc(
        code: 'P0171',
        scope: 'standard',
        description: 'System too lean',
      ),
    ],
  );
}

Future<void> pumpList(
  WidgetTester tester, {
  double width = 400,
  double height = 800,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        templateIndexProvider
            .overrideWith((ref) async => Future.value(fakeIndex())),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TemplateListPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> pumpDetail(
  WidgetTester tester, {
  double width = 400,
  double height = 800,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        templateByIdProvider.overrideWith(
          (ref, id) async => Future.value(fakeResolution()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TemplateDetailPage(vehicleId: 'toyota-corolla'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('list page renders without GlobalKey errors (narrow)',
      (tester) async {
    await pumpList(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Toyota Corolla'), findsOneWidget);
  });

  testWidgets('list page renders without GlobalKey errors (wide)',
      (tester) async {
    await pumpList(tester, width: 900, height: 700);
    await tester.pumpAndSettle();
    expect(find.text('Toyota Corolla'), findsWidgets);
  });

  testWidgets('detail page renders and opens DTC sheet', (tester) async {
    await pumpDetail(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Toyota Corolla E210'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('fault code'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('fault code'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'P0171');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('System too lean'), findsOneWidget);
  });
}