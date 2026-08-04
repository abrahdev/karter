import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/services/in_app_purchase_service.dart';
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
          ? const Center(
              child: M3LoadingIndicator(
                  contained: true, size: 36, containerSize: 72))
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
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
                ..._buildSubscriptionTiers(context, ref, iapState, theme),

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

  List<Widget> _buildSubscriptionTiers(
    BuildContext context,
    WidgetRef ref,
    IapState iapState,
    ThemeData theme,
  ) {
    final l = AppLocalizations.of(context)!;

    ProductDetails? productFor(String basePlanId) {
      for (final p in iapState.products) {
        if (p is GooglePlayProductDetails && p.id == kSubscriptionId) {
          final offer = p.productDetails.subscriptionOfferDetails;
          if (offer != null && p.subscriptionIndex != null) {
            final id = offer[p.subscriptionIndex!].basePlanId;
            if (id == basePlanId) return p;
          }
        }
      }
      return null;
    }

    final tiers = [
      (tier: l.tipBronze, price: l.tipBronzeMonthly, basePlanId: 'karter-bronze-monthly'),
      (tier: l.tipSilver, price: l.tipSilverMonthly, basePlanId: 'karter-silver-monthly'),
      (tier: l.tipGold, price: l.tipGoldMonthly, basePlanId: 'karter-gold-monthly'),
    ];

    return tiers.map((t) {
      final product = productFor(t.basePlanId);
      return _TipCard(
        tier: t.tier,
        price: t.price,
        sku: kSubscriptionId,
        product: product,
      );
    }).toList();
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
  final ProductDetails? product;

  const _TipCard({
    required this.tier,
    required this.price,
    required this.sku,
    this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final iapState = ref.watch(iapProvider);
    final isSubscription = sku == kSubscriptionId;
    final purchased = isSubscription
        ? iapState.purchased.contains(kSubscriptionId)
        : iapState.purchased.contains(sku);
    final buying = iapState.buying;
    final resolvedProduct = product ??
        (iapState.products.cast<ProductDetails?>().firstWhere(
          (p) => p?.id == sku,
          orElse: () => null,
        ));
    final l = AppLocalizations.of(context)!;

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
              ? l.tipPurchased
              : resolvedProduct != null ? resolvedProduct.price : price,
        ),
        trailing: purchased
            ? null
            : FilledButton.tonal(
                onPressed: buying
                    ? null
                    : () async {
                        ref.read(hapticProvider.notifier).mediumTap();
                        final notifier = ref.read(iapProvider.notifier);
                        if (resolvedProduct != null) {
                          await notifier.buy(resolvedProduct);
                        }
                      },
                child: buying
                    ? const M3LoadingIndicator(size: 16)
                    : Text(l.tipSupport),
              ),
      ),
    );
  }
}
