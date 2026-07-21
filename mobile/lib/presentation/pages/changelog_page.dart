import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mobile/l10n/app_localizations.dart';

class ChangelogPage extends StatefulWidget {
  const ChangelogPage({super.key});

  @override
  State<ChangelogPage> createState() => _ChangelogPageState();
}

class _ChangelogPageState extends State<ChangelogPage> {
  String? _content;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString('CHANGELOG.md');
      if (mounted) setState(() => _content = raw);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.changelog)),
      body: _content != null
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  _content!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            )
          : _error != null
              ? Center(child: Text(_error!))
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
