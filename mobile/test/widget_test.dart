import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('App renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: KarterApp()));
    await tester.pump();

    expect(find.text('Karter'), findsWidgets);
  });
}
