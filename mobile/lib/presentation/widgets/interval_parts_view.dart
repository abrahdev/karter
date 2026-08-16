import 'package:flutter/material.dart';
import 'package:mobile/domain/entities/maintenance_interval.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/utils/maintenance_localizer.dart';
import 'package:mobile/presentation/utils/part_line_formatter.dart';
import 'package:mobile/presentation/utils/url_helpers.dart';

class IntervalPartsView extends StatelessWidget {
  final List<IntervalPart> parts;

  const IntervalPartsView({super.key, required this.parts});

  static String formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.round().toString();
    }
    return quantity.toString();
  }

  static String unitLabel(BuildContext context, String? unit) {
    final l = AppLocalizations.of(context)!;
    switch (unit) {
      case 'unit':
        return l.partUnitUnit;
      case 'set':
        return l.partUnitSet;
      case 'kit':
        return l.partUnitKit;
      case 'can':
        return l.partUnitCan;
      default:
        return unit ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = AppLocalizations.of(context)!.localeName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final part in parts)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _partText(context, locale, part),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (part.links.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openLink(context, part.links.first),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.link,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _openLink(BuildContext context, String url) =>
      openLink(context, url);

  String _partText(BuildContext context, String locale, IntervalPart part) {
    final name = localizedLabel(locale, part.i18nKey, part.name ?? part.partId);
    final unit = unitLabel(context, part.unit);
    return formatPartLine(
      name: name,
      formattedQuantity: formatQuantity(part.quantity),
      unitLabel: unit,
    );
  }
}
