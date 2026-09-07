import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/changelog_page.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _docsUrl = 'https://abrahdev.github.io/karter/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    final leftSections = <Widget>[
      SectionHeader(title: l.sectionPreferences),
      const _PreferencesCard(),
      SectionHeader(title: l.sectionData),
      const _DataCard(),
    ];

    final rightSections = <Widget>[
      SectionHeader(title: l.sectionAbout),
      const _AboutCard(),
      const SizedBox(height: 4),
      Center(
        child: Text(
          l.moreFooter,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.pagePadding,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: _MoreHeader(),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(AppSpacing.pagePadding),
                        children: leftSections,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(AppSpacing.pagePadding),
                        children: rightSections,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            const _MoreHeader(),
            ...leftSections,
            ...rightSections,
          ],
        );
      },
    );
  }
}

class _MoreHeader extends ConsumerWidget {
  const _MoreHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Text(
            'Karter',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              final version = info != null
                  ? 'v${info.version}+${info.buildNumber}'
                  : '...';
              return Text(
                version,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends ConsumerWidget {
  const _PreferencesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final localeNotifier = ref.watch(localeProvider.notifier);

    final themeLabel = switch (themeMode) {
      ThemeMode.light => l.themeLight,
      ThemeMode.dark => l.themeDark,
      ThemeMode.system => l.themeSystem,
    };

    final languageLabel = _languageLabel(localeNotifier, l, ref);

    return GroupedCard(
      children: [
        ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          title: Text(l.theme),
          subtitle: Text(themeLabel),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemePicker(context, ref, themeMode),
        ),
        ListTile(
          leading: const Icon(Icons.tune),
          title: Text(l.morePersonalization),
          subtitle: Text(l.morePersonalizationSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/more/personalization'),
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: Text(l.moreNotifications),
          subtitle: Text(l.moreNotificationsSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/notifications'),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l.language),
          subtitle: Text(languageLabel),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguagePicker(context, ref),
        ),
      ],
    );
  }
}

class _DataCard extends ConsumerWidget {
  const _DataCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return GroupedCard(
      children: [
        ListTile(
          leading: const Icon(Icons.grid_view_outlined),
          title: Text(l.templatesTitle),
          subtitle: Text(l.templatesSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/more/source'),
        ),
        ListTile(
          leading: const Icon(Icons.cloud_upload_outlined),
          title: Text(l.moreBackup),
          subtitle: Text(l.moreBackupSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/more/backups'),
        ),
      ],
    );
  }
}

class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return GroupedCard(
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l.moreAbout),
          subtitle: Text(l.moreDescription),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/more/about'),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: Text(l.privacyPolicy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/privacy'),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(l.changelog),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => karterShowModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const ChangelogSheet(),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.menu_book),
          title: Text(l.moreDocs),
          subtitle: Text(l.moreDocsSubtitle),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => _openUrl(context, MorePage._docsUrl),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l.onboardingReplay),
          subtitle: Text(l.onboardingReplaySubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/onboarding'),
        ),
        ListTile(
          leading: const Icon(Icons.rate_review),
          title: Text(l.moreFeedback),
          subtitle: Text(l.moreFeedbackSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/feedback'),
        ),
      ],
    );
  }
}

String _languageLabel(LocaleNotifier notifier, AppLocalizations l, WidgetRef ref) {
  if (notifier.isSystem) return l.languageSystem;
  final code = ref.read(localeProvider).languageCode;
  return switch (code) {
    'es' => l.spanish,
    'et' => l.eesti,
    'pt' => l.portuguese,
    'de' => l.german,
    'ru' => l.russian,
    'fr' => l.french,
    'pl' => l.polish,
    'it' => l.italian,
    'nl' => l.dutch,
    _ => l.english,
  };
}

Future<void> _openUrl(BuildContext context, String url) async {
  final l = AppLocalizations.of(context)!;
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.moreUrlError(url))),
    );
  }
}

void _showLanguagePicker(BuildContext context, WidgetRef ref) {
  final l = AppLocalizations.of(context)!;
  final notifier = ref.read(localeProvider.notifier);
  final currentCode = notifier.isSystem
      ? LocaleNotifier.systemCode
      : ref.read(localeProvider).languageCode;
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
                title: Text(l.languageSystem),
                value: LocaleNotifier.systemCode,
              ),
              RadioListTile<String>(title: Text(l.english), value: 'en'),
              RadioListTile<String>(title: Text(l.spanish), value: 'es'),
              RadioListTile<String>(title: Text(l.eesti), value: 'et'),
              RadioListTile<String>(title: Text(l.portuguese), value: 'pt'),
              RadioListTile<String>(title: Text(l.german), value: 'de'),
              RadioListTile<String>(title: Text(l.russian), value: 'ru'),
              RadioListTile<String>(title: Text(l.french), value: 'fr'),
              RadioListTile<String>(title: Text(l.polish), value: 'pl'),
              RadioListTile<String>(title: Text(l.italian), value: 'it'),
              RadioListTile<String>(title: Text(l.dutch), value: 'nl'),
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