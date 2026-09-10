import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show BlockPicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/shake_to_odometer_provider.dart';
import 'package:mobile/presentation/providers/surface_tint_provider.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';

class PersonalizationPage extends ConsumerWidget {
  const PersonalizationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final surfaceTint = ref.watch(surfaceTintProvider);
    final seedColorState = ref.watch(seedColorProvider);
    final hapticMode = ref.watch(hapticProvider);
    final shakeToOdometerEnabled = ref.watch(shakeToOdometerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.morePersonalization)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          GroupedCard(
            children: [
              KarterSwitchListTile(
                leading: const Icon(Icons.format_color_fill),
                title: Text(l.colorOfInterface),
                subtitle: Text(l.colorOfInterfaceDesc),
                value: surfaceTint,
                onChanged: (v) =>
                    ref.read(surfaceTintProvider.notifier).toggle(v),
              ),
              KarterSwitchListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l.customColor),
                subtitle: Text(l.customColorDesc),
                value: seedColorState.useCustom,
                onChanged: (v) =>
                    ref.read(seedColorProvider.notifier).setUseCustom(v),
              ),
              if (seedColorState.useCustom)
                ListTile(
                  leading: const Icon(Icons.circle, size: 24),
                  title: Text(l.colorScheme),
                  subtitle: Text(seedColorState.customArgb != null
                      ? l.colorCustom
                      : l.selectColor),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: seedColorState.color,
                        radius: 12,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => _pickColor(context, ref, seedColorState),
                ),
              ExpansionTile(
                leading: const Icon(Icons.vibration),
                title: Text(l.hapticFeedback),
                subtitle: Text(l.hapticFeedbackDesc),
                children: [
                  RadioGroup<HapticMode>(
                    groupValue: hapticMode,
                    onChanged: (v) {
                      ref.read(hapticProvider.notifier).setMode(v!);
                      _demoHaptic(v);
                    },
                    child: Column(
                      children: [
                        RadioListTile<HapticMode>(
                          title: Text(l.hapticModeOff),
                          subtitle: Text(l.hapticModeOffDesc),
                          value: HapticMode.off,
                        ),
                        RadioListTile<HapticMode>(
                          title: Text(l.hapticModeClear),
                          subtitle: Text(l.hapticModeClearDesc),
                          value: HapticMode.clear,
                        ),
                        RadioListTile<HapticMode>(
                          title: Text(l.hapticModeRich),
                          subtitle: Text(l.hapticModeRichDesc),
                          value: HapticMode.rich,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              KarterSwitchListTile(
                leading: const Icon(Icons.screen_rotation),
                title: Text(l.shakeToOdometer),
                subtitle: Text(l.shakeToOdometerDesc),
                value: shakeToOdometerEnabled,
                onChanged: (v) =>
                    ref.read(shakeToOdometerProvider.notifier).toggle(v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickColor(
    BuildContext context,
    WidgetRef ref,
    SeedColorState current,
  ) async {
    final l = AppLocalizations.of(context)!;
    Color picked = current.color;

    final color = await showDialog<Color>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.colorScheme),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: picked,
            onColorChanged: (c) => picked = c,
          ),
        ),
        actions: [
          if (current.customArgb != null)
            TextButton(
              onPressed: () => Navigator.pop(ctx, Colors.amber),
              child: Text(l.resetToDefault),
            ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, picked),
            child: Text(l.saveChangesShort),
          ),
        ],
      ),
    );

    if (color != null && context.mounted) {
      if (color == Colors.amber) {
        await ref.read(seedColorProvider.notifier).resetColor();
      } else {
        await ref.read(seedColorProvider.notifier).setColor(color);
      }
    }
  }
}

void _demoHaptic(HapticMode mode) {
  switch (mode) {
    case HapticMode.off:
      break;
    case HapticMode.clear:
      HapticFeedback.mediumImpact();
      break;
    case HapticMode.rich:
      HapticFeedback.mediumImpact();
      Future.delayed(
        const Duration(milliseconds: 60),
        () => HapticFeedback.lightImpact(),
      );
      break;
  }
}