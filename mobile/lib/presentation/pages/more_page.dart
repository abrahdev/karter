import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/rating_helper.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/onboarding_page.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
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
            leading: const Icon(Icons.help_outline),
            title: Text(l.onboardingReplay),
            subtitle: Text(l.onboardingReplaySubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const OnboardingPage(),
                ),
              );
            },
          ),
        ),
        const Divider(),
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
        _TemplateSourceSection(),
        const Divider(),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.rate_review),
            title: Text(l.moreRate),
            subtitle: Text(l.moreRateSubtitle),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => openStorePage(),
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

class _TemplateSourceSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final config = ref.watch(templateSourceProvider);

    return Column(
      children: [
        Material(
          color: theme.colorScheme.surface,
          child: SwitchListTile(
            secondary: Icon(config.enabled ? Icons.cloud : Icons.storage),
            title: Text(l.moreTemplateSource),
            subtitle: Text(l.moreTemplateSourceSubtitle),
            value: config.enabled,
            onChanged: (v) => ref.read(templateSourceProvider.notifier).setEnabled(v),
          ),
        ),
        if (config.enabled) ...[
          const Divider(height: 1, indent: 16, endIndent: 16),
          Material(
            color: theme.colorScheme.surface,
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(l.moreTemplateSourceUrl),
              subtitle: Text(
                config.repoUrl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.edit),
              onTap: () => _editUrl(context, ref, config.repoUrl),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editUrl(BuildContext context, WidgetRef ref, String currentUrl) async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentUrl);

    final result = await karterShowDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.moreTemplateSourceEditUrl),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l.moreTemplateSourceUrlHint,
          ),
          keyboardType: TextInputType.url,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(templateSourceProvider.notifier).resetToDefault();
              Navigator.pop(ctx);
            },
            child: Text(l.moreTemplateSourceReset),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                Navigator.pop(ctx, url);
              }
            },
            child: Text(l.saveChangesShort),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await ref.read(templateSourceProvider.notifier).setRepoUrl(result);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.moreTemplateSourceUrlSaved)),
        );
      }
    }
  }
}
