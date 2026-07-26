import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';

class KarterSegmentedButton<T> extends StatelessWidget {
  const KarterSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.style,
    this.hapticFeedback = true,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final ButtonStyle? style;
  final bool hapticFeedback;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged != null
          ? (v) {
              if (hapticFeedback) {
                ProviderScope.containerOf(context).read(hapticProvider.notifier).selectionTap();
              }
              onSelectionChanged!.call(v);
            }
          : null,
      style: style,
    );
  }
}
