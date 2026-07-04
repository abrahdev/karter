import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/domain/enums/distance_unit.dart';
import 'package:mobile/domain/value_objects/odometer.dart';
import 'package:mobile/l10n/app_localizations.dart';

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

  static const _kOutlierThreshold = 5000.0;

  @override
  void initState() {
    super.initState();
    _rawValue = widget.current.distance;
    _controller = TextEditingController(text: _format(_rawValue));
  }

  @override
  void dispose() {
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

  void _add(double delta) {
    final newValue = (_rawValue + delta).clamp(0, 9999999);
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

    final mediaQuery = MediaQuery.of(context);
    final isNarrow = mediaQuery.size.width < 480;

    return AlertDialog(
      title: Text(l.odometerUpdateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                _quickBtn(
                    Icons.remove_circle_outline, -10, theme),
                _quickBtn(null, -1, theme),
                _quickBtn(null, 1, theme),
                _quickBtn(Icons.add_circle_outline, 10, theme),
              ],
            ),
          ] else ...[
            Row(
              children: [
                _quickBtn(
                    Icons.remove_circle_outline, -10, theme),
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
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[\d.]')),
                    ],
                    decoration: InputDecoration(
                      suffixText: _unitLabel(),
                      border: const OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
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
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _chip(100, theme),
              _chip(500, theme),
              _chip(1000, theme),
              _chip(5000, theme),
            ],
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.odometerCancel),
        ),
        FilledButton(
          onPressed: _rawValue >= 0 && _rawValue != currentKm
              ? () async {
                  await widget.onSave(_rawValue);
                  if (context.mounted) Navigator.pop(context);
                }
              : null,
          child: Text(l.odometerSave),
        ),
      ],
    );
  }

  Widget _quickBtn(IconData? icon, int delta, ThemeData theme) {
    return IconButton(
      icon: Icon(
        icon ?? (delta < 0 ? Icons.remove : Icons.add),
      ),
      onPressed: () => _add(delta.toDouble()),
      tooltip: delta < 0 ? '${delta.abs()}' : '+$delta',
      iconSize: 20,
    );
  }

  Widget _chip(int value, ThemeData theme) {
    final isNegative = value < 0;
    final label = isNegative ? '$value' : '+$value';
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
