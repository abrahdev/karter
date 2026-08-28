import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/presentation/providers/catalog_sources_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('defaults to the bundled (builtin) catalog', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(catalogSourcesProvider);
              return Text(state.active?.id ?? 'none');
            },
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('builtin'), findsOneWidget);
  });

  test('builtin source is not deletable and online is listed', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    final state = container.read(catalogSourcesProvider);
    expect(state.sources.map((s) => s.id), containsAll(['builtin', 'online']));
    expect(
      state.sources.firstWhere((s) => s.id == 'builtin').deletable,
      isFalse,
    );
    expect(
      state.sources.firstWhere((s) => s.id == 'online').deletable,
      isFalse,
    );

    // Deleting the builtin source is a no-op.
    await container
        .read(catalogSourcesProvider.notifier)
        .deleteSource('builtin');
    final after = container.read(catalogSourcesProvider);
    expect(after.sources.map((s) => s.id), contains('builtin'));
    expect(after.activeId, 'builtin');
  });
}