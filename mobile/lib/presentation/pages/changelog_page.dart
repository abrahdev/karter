import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ChangelogSheet extends StatefulWidget {
  const ChangelogSheet({super.key});

  @override
  State<ChangelogSheet> createState() => _ChangelogSheetState();
}

class _ChangelogSheetState extends State<ChangelogSheet> {
  String? _version;
  String? _content;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = '${info.version}+${info.buildNumber}';
      final raw = await rootBundle.loadString('CHANGELOG.md');
      final section = _extractVersion(raw, version);
      if (mounted) {
        setState(() {
          _version = info.version;
          _content = section;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  static String _extractVersion(String raw, String version) {
    final lines = raw.split('\n');
    final header = '## [$version]';
    final start = lines.indexWhere((l) => l.startsWith(header));
    if (start == -1) return raw;

    final end = lines.indexWhere(
      (l) => l.startsWith('## [') && l != lines[start],
      start + 1,
    );

    final slice = lines.sublist(start, end == -1 ? lines.length : end);
    return slice.join('\n').replaceFirst(RegExp(r'^## \[.*?\]\s*-\s*\d{4}-\d{2}-\d{2}\n'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.changelog,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              if (_version != null)
                Text(
                  'v$_version',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_content != null)
          Flexible(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              shrinkWrap: true,
              children: _buildItems(_content!),
            ),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_error!, style: TextStyle(color: cs.error)),
          )
        else
          const Padding(
            padding: EdgeInsets.all(24),
            child: M3LoadingIndicator(),
          ),
      ],
    );
  }

  List<Widget> _buildItems(String content) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final lines = content.split('\n');
    final widgets = <Widget>[];
    String? currentSection;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('### ')) {
        currentSection = trimmed.substring(4);
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              currentSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('- ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: cs.onSurfaceVariant)),
                Expanded(
                  child: Text(
                    trimmed.substring(2),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }
}
