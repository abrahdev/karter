import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show BlockPicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/onboarding_page.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
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
    final themeMode = ref.watch(themeModeProvider);
    final seedColorState = ref.watch(seedColorProvider);

    final themeLabel = switch (themeMode) {
      ThemeMode.light => l.themeLight,
      ThemeMode.dark => l.themeDark,
      ThemeMode.system => l.themeSystem,
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.moreAbout, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l.moreDescription, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),

        _SectionHeader(title: l.sectionGeneral),
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
            leading: const Icon(Icons.dark_mode_outlined),
            title: Text(l.theme),
            subtitle: Text(themeLabel),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref, themeMode),
          ),
        ),
        const Divider(),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l.colorScheme),
            subtitle: Text(SeedColorNotifier.labelFor(seedColorState.name)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showColorPicker(context, ref, seedColorState.name),
          ),
        ),

        _SectionHeader(title: l.sectionDataSecurity),
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
        _TemplateSourceSection(),

        _SectionHeader(title: l.sectionFeedbackCommunity),
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            leading: const Icon(Icons.rate_review),
            title: Text(l.moreFeedback),
            subtitle: Text(l.moreFeedbackSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/feedback'),
          ),
        ),
        const Divider(),
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

        _SectionHeader(title: l.sectionDocsDonate),
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
        const Divider(),
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
                RadioListTile<String>(title: Text(l.english), value: 'en'),
                RadioListTile<String>(title: Text(l.spanish), value: 'es'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, ThemeMode current) {
    final l = AppLocalizations.of(context)!;
    karterShowDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.theme),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: current,
            onChanged: (v) {
              ref.read(themeModeProvider.notifier).setThemeMode(v!);
              Navigator.pop(ctx);
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: Text(l.themeSystem),
                  subtitle: Text(l.themeSystemDesc),
                  value: ThemeMode.system,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l.themeLight),
                  value: ThemeMode.light,
                ),
                RadioListTile<ThemeMode>(
                  title: Text(l.themeDark),
                  value: ThemeMode.dark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref, String current) {
    final l = AppLocalizations.of(context)!;
    final colors = SeedColorNotifier.presetNames;
    final customKey = SeedColorNotifier.customKey;
    final isCustom = current == customKey;

    karterShowDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.colorScheme),
        children: [
          RadioGroup<String>(
            groupValue: isCustom ? customKey : current,
            onChanged: (v) {
              if (v != null) {
                if (v == customKey) {
                  Navigator.pop(ctx);
                  _pickCustomColor(context, ref);
                } else {
                  ref.read(seedColorProvider.notifier).setColor(v);
                  Navigator.pop(ctx);
                }
              }
            },
            child: Column(
              children: [
                ...colors.map((name) => RadioListTile<String>(
                      title: Text(SeedColorNotifier.labelFor(name)),
                      value: name,
                    )),
                RadioListTile<String>(
                  title: Text(l.colorCustom),
                  value: customKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCustomColor(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context)!;
    Color picked = Theme.of(context).colorScheme.primary;

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
      await ref.read(seedColorProvider.notifier).setCustomColor(color);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
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
            onChanged: (v) =>
                ref.read(templateSourceProvider.notifier).setEnabled(v),
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

  Future<void> _editUrl(
      BuildContext context, WidgetRef ref, String currentUrl) async {
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
              if (url.isNotEmpty) Navigator.pop(ctx, url);
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
