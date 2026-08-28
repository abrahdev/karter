import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/template_creator_page.dart';

Future<void> pumpCreator(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TemplateCreatorPage(),
    ),
  );
}

void main() {
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
}