import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/iap_provider.dart';

class TipsPage extends ConsumerWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final iapState = ref.watch(iapProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.tipProgram)),
      body: iapState.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (iapState.error != null)
                  Card(
                    color: theme.colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: theme.colorScheme.onErrorContainer),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              iapState.error!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (ref.read(iapProvider.notifier).hasAnyBadge()) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: _badgeColor(
                                ref.read(iapProvider.notifier).highestBadge(),
                                theme),
                            child: Icon(Icons.favorite,
                                color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l.supporterBadge,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(l.tipInfo, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  l.tipInfoText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                Text(l.tipOneTime, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _TipCard(
                  tier: l.tipBronze,
                  price: l.tipBronzePrice,
                  sku: 'karter_bronze_one',
                ),
                _TipCard(
                  tier: l.tipSilver,
                  price: l.tipSilverPrice,
                  sku: 'karter_silver_one',
                ),
                _TipCard(
                  tier: l.tipGold,
                  price: l.tipGoldPrice,
                  sku: 'karter_gold_one',
                ),

                const SizedBox(height: 24),

                Text(l.tipRecurring, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                _TipCard(
                  tier: l.tipBronze,
                  price: l.tipBronzeMonthly,
                  sku: 'karter_bronze_monthly',
                ),
                _TipCard(
                  tier: l.tipSilver,
                  price: l.tipSilverMonthly,
                  sku: 'karter_silver_monthly',
                ),
                _TipCard(
                  tier: l.tipGold,
                  price: l.tipGoldMonthly,
                  sku: 'karter_gold_monthly',
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: iapState.loading
                        ? null
                        : () => ref.read(iapProvider.notifier).restore(),
                    icon: const Icon(Icons.restore),
                    label: Text(l.restorePurchases),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
    );
  }

  Color _badgeColor(String? badge, ThemeData theme) {
    return switch (badge) {
      'gold' => const Color(0xFFFFD700),
      'silver' => const Color(0xFFC0C0C0),
      'bronze' => const Color(0xFFCD7F32),
      _ => theme.colorScheme.primary,
    };
  }
}

class _TipCard extends ConsumerWidget {
  final String tier;
  final String price;
  final String sku;

  const _TipCard({
    required this.tier,
    required this.price,
    required this.sku,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final iapState = ref.watch(iapProvider);
    final purchased = iapState.purchased.contains(sku);
    final buying = iapState.buying;
    final product = iapState.products.where((p) => p.id == sku).toList();

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: purchased
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: purchased
              ? Icon(Icons.check, color: theme.colorScheme.primary)
              : Icon(Icons.favorite, color: theme.colorScheme.primary),
        ),
        title: Text(tier),
        subtitle: Text(
          purchased
              ? l10n(context).tipPurchased
              : product.isNotEmpty ? product.first.price : price,
        ),
        trailing: purchased
            ? null
            : FilledButton.tonal(
                onPressed: buying
                    ? null
                    : () async {
                        ref.read(hapticProvider.notifier).mediumTap();
                        final notifier = ref.read(iapProvider.notifier);
                        if (product.isNotEmpty) {
                          await notifier.buy(product.first);
                        }
                      },
                child: buying
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n(context).tipSupport),
              ),
      ),
    );
  }

  AppLocalizations l10n(BuildContext context) =>
      AppLocalizations.of(context)!;
}
