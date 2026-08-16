import 'package:flutter/material.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/widgets/drag_handle.dart';

Future<void> showNewVehicleServicesOverdueModal(BuildContext context) {
  return karterShowModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => const _NewVehicleOverdueModal(),
  );
}

class _NewVehicleOverdueModal extends StatelessWidget {
  const _NewVehicleOverdueModal();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        const DragHandle(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: cs.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l.newVehicleServicesOverdueTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                l.newVehicleServicesOverdueBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.gotIt),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
