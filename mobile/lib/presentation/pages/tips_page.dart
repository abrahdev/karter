import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.tipProgram)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.construction, color: theme.colorScheme.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l.tipProgramComingSoon,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(l.tipBadges, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l.tipBadgesNone, style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          )),

          const SizedBox(height: 24),

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
          _TipCard(tier: l.tipBronze, price: l.tipBronzePrice, enabled: false),
          _TipCard(tier: l.tipSilver, price: l.tipSilverPrice, enabled: false),
          _TipCard(tier: l.tipGold, price: l.tipGoldPrice, enabled: false),

          const SizedBox(height: 24),

          Text(l.tipRecurring, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _TipCard(tier: l.tipBronze, price: l.tipBronzeMonthly, enabled: false),
          _TipCard(tier: l.tipSilver, price: l.tipSilverMonthly, enabled: false),
          _TipCard(tier: l.tipGold, price: l.tipGoldMonthly, enabled: false),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String tier;
  final String price;
  final bool enabled;

  const _TipCard({required this.tier, required this.price, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(Icons.favorite, color: theme.colorScheme.primary),
        ),
        title: Text(tier),
        subtitle: Text(price),
        trailing: enabled ? FilledButton.tonal(
          onPressed: () {},
          child: const Text('Tip'),
        ) : TextButton(
          onPressed: null,
          child: Text(tier),
        ),
      ),
    );
  }
}
