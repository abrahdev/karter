import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: KarterApp(initialAccent: Colors.blue),
      ),
    );
    await tester.pump();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
