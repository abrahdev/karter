import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';

class KarterSwitchListTile extends StatelessWidget {
  const KarterSwitchListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.title,
    this.subtitle,
    this.contentPadding,
    this.dense = false,
    this.hapticFeedback = true,
    this.onTap,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final bool hapticFeedback;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        contentPadding: contentPadding,
        dense: dense,
        trailing: Switch(
          value: value,
          onChanged: onChanged != null
              ? (v) {
                  if (hapticFeedback) {
                    ProviderScope.containerOf(context)
                        .read(hapticProvider.notifier)
                        .success();
                  }
                  onChanged!.call(v);
                }
              : null,
        ),
        onTap: onTap,
      );
    }

    return SwitchListTile(
      secondary: leading,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged != null
          ? (v) {
              if (hapticFeedback) {
                ProviderScope.containerOf(context)
                    .read(hapticProvider.notifier)
                    .success();
              }
              onChanged!.call(v);
            }
          : null,
      contentPadding: contentPadding,
      dense: dense,
    );
  }
}
