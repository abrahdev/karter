import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';

class OdometerDialog extends StatefulWidget {
  final Odometer current;
  final Future<void> Function(double newDistance) onSave;

  const OdometerDialog({
    super.key,
    required this.current,
    required this.onSave,
  });

  @override
  State<OdometerDialog> createState() => _OdometerDialogState();
}

class _OdometerDialogState extends State<OdometerDialog> {
  late TextEditingController _controller;
  double _rawValue = 0;
  String? _warning;
  Timer? _repeatTimer;

  static const _kOutlierThreshold = 5000.0;

  @override
  void initState() {
    super.initState();
    _rawValue = widget.current.distance;
    _controller = TextEditingController(text: _format(_rawValue));
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String _format(double v) {
    final parts = v.toStringAsFixed(0).split('');
    final result = <String>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) result.add('.');
      result.add(parts[i]);
    }
    return result.join();
  }

  double _parse(String text) {
    return double.tryParse(text.replaceAll('.', '')) ?? 0;
  }

  void _hapticForDelta(int delta) {
    final abs = delta.abs();
    final haptic = ProviderScope.containerOf(context).read(hapticProvider.notifier);
    if (abs >= 1000) {
      haptic.heavyTap();
    } else if (abs >= 100) {
      haptic.mediumTap();
    } else if (abs >= 10) {
      haptic.mediumTap();
    } else {
      haptic.lightTap();
    }
  }

  void _startRepeat(double delta) {
    _add(delta);
    var delay = 300;
    _repeatTimer?.cancel();
    _repeatTick(delta, delay);
  }

  void _repeatTick(double delta, int delay) {
    _repeatTimer?.cancel();
    _repeatTimer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _add(delta);
      final nextDelay = (delay * 0.6).toInt().clamp(25, 300);
      _repeatTick(delta, nextDelay);
    });
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  void _add(double delta) {
    final newValue = (_rawValue + delta).clamp(0, 9999999);
    _hapticForDelta(delta.toInt());
    setState(() {
      _rawValue = newValue.toDouble();
      _controller.text = _format(_rawValue);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _validate();
    });
  }

  void _validate() {
    final l = AppLocalizations.of(context);
    if (l == null) return;
    final currentKm = widget.current.distance;
    final delta = _rawValue - currentKm;

    if (delta < 0) {
      _warning = l.odometerLowerWarning(_unitLabel(), _format(currentKm));
    } else if (delta > _kOutlierThreshold) {
      _warning = l.odometerDeltaWarning(_format(delta), _unitLabel());
    } else {
      _warning = null;
    }
  }

  String _unitLabel() {
    return widget.current.unit == DistanceUnit.kilometers ? 'km' : 'mi';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final currentKm = widget.current.distance;

    final isNarrow = MediaQuery.of(context).size.width < 480;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(l.odometerUpdateTitle,
                style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l.odometerLastReading(_unitLabel(), _format(currentKm)),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (isNarrow) ...[
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                decoration: InputDecoration(
                  suffixText: _unitLabel(),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 12),
                ),
                onChanged: (v) {
                  setState(() {
                    _rawValue = _parse(v);
                    _validate();
                  });
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _quickBtn(Icons.remove_circle_outline, -10, theme)),
                  Expanded(child: _quickBtn(null, -1, theme)),
                  const Spacer(flex: 2),
                  Expanded(child: _quickBtn(null, 1, theme)),
                  Expanded(child: _quickBtn(Icons.add_circle_outline, 10, theme)),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  _quickBtn(Icons.remove_circle_outline, -10, theme),
                  const SizedBox(width: 4),
                  _quickBtn(null, -1, theme),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                      ],
                      decoration: InputDecoration(
                        suffixText: _unitLabel(),
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                      onChanged: (v) {
                        setState(() {
                          _rawValue = _parse(v);
                          _validate();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _quickBtn(null, 1, theme),
                  const SizedBox(width: 4),
                  _quickBtn(Icons.add_circle_outline, 10, theme),
                ],
              ),
            ],
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _chip(100, theme),
                  _chip(500, theme),
                  _chip(1000, theme),
                  _chip(5000, theme),
                ],
              ),
            ),
            if (_warning != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: theme.colorScheme.onErrorContainer,
                        size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _warning!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ProviderScope.containerOf(context)
                          .read(hapticProvider.notifier)
                          .lightTap();
                      Navigator.pop(context);
                    },
                    child: Text(l.odometerCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _rawValue >= 0 && _rawValue != currentKm
                        ? () async {
                            ProviderScope.containerOf(context)
                                .read(hapticProvider.notifier)
                                .success();
                            await widget.onSave(_rawValue);
                            if (context.mounted) Navigator.pop(context);
                          }
                        : null,
                    child: Text(l.odometerSave),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickBtn(IconData? icon, int delta, ThemeData theme) {
    return Tooltip(
      message: delta < 0 ? '${delta.abs()}' : '+$delta',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _add(delta.toDouble()),
        onLongPressStart: (_) => _startRepeat(delta.toDouble()),
        onLongPressEnd: (_) => _stopRepeat(),
        onLongPressCancel: () => _stopRepeat(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon ?? (delta < 0 ? Icons.remove : Icons.add),
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _chip(int value, ThemeData theme) {
    final isNegative = value < 0;
    final label = '$value';
    return ActionChip(
      avatar: Icon(
        isNegative ? Icons.remove : Icons.add,
        size: 16,
      ),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      onPressed: () => _add(value.toDouble()),
    );
  }
}
