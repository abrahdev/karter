import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _repoUrl = 'https://github.com/abrahdev/karter';
  static const _docsUrl = 'https://abrahdev.github.io/karter/';
  static const _sponsorsUrl = 'https://github.com/sponsors/abrahdev';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.moreAbout,
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  l.moreDescription,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l.moreNotifications),
            subtitle: Text(l.moreNotificationsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/notifications'),
          ),
        ),
        const Divider(),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.storage),
            title: Text(l.moreExport),
            subtitle: Text(l.moreExportSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/data'),
          ),
        ),
        const Divider(),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            subtitle: Text(locale.languageCode == 'en' ? l.english : l.spanish),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, ref),
          ),
        ),
        const Divider(),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text(l.moreDocs),
            subtitle: Text(l.moreDocsSubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openUrl(context, _docsUrl),
          ),
        ),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.code),
            title: Text(l.moreSource),
            subtitle: Text(l.moreSourceSubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openUrl(context, _repoUrl),
          ),
        ),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: Text(l.moreDonate),
            subtitle: Text(l.moreDonateSubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _openUrl(context, _sponsorsUrl),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            l.moreFooter,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final l = AppLocalizations.of(context)!;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.moreUrlError(url))),
        );
      }
    }
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final currentCode = ref.read(localeProvider).languageCode;
    karterShowDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.selectLanguage),
        children: [
          RadioGroup<String>(
            groupValue: currentCode,
            onChanged: (v) {
              ref.read(localeProvider.notifier).setLocale(v!);
              Navigator.pop(ctx);
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l.english),
                  value: 'en',
                ),
                RadioListTile<String>(
                  title: Text(l.spanish),
                  value: 'es',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
