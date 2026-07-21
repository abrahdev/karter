import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show BlockPicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/changelog_page.dart';
import 'package:mobile/presentation/pages/onboarding_page.dart';
import 'package:mobile/presentation/pages/privacy_policy_page.dart';
import 'package:mobile/presentation/pages/tips_page.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/surface_tint_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  static const _repoUrl = 'https://github.com/abrahdev/karter';
  static const _docsUrl = 'https://abrahdev.github.io/karter/';
  static const _sponsorsUrl = 'https://github.com/sponsors/abrahdev';
  static const _weblateUrl = 'https://hosted.weblate.org/engage/karter/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final seedColorState = ref.watch(seedColorProvider);
    final hapticEnabled = ref.watch(hapticProvider);
    final surfaceTint = ref.watch(surfaceTintProvider);
    final localeNotifier = ref.watch(localeProvider.notifier);

    final themeLabel = switch (themeMode) {
      ThemeMode.light => l.themeLight,
      ThemeMode.dark => l.themeDark,
      ThemeMode.system => l.themeSystem,
    };

    final languageLabel = _languageLabel(localeNotifier, l);

    final narrow = LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SectionHeader(title: l.sectionPreferences),
                      _GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.dark_mode_outlined),
                            title: Text(l.theme),
                            subtitle: Text(themeLabel),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showThemePicker(context, ref, themeMode),
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.format_color_fill),
                            title: Text(l.colorOfInterface),
                            subtitle: Text(l.colorOfInterfaceDesc),
                            value: surfaceTint,
                            onChanged: (v) =>
                                ref.read(surfaceTintProvider.notifier).toggle(v),
                          ),
                          SwitchListTile(
                            secondary: const Icon(Icons.palette_outlined),
                            title: Text(l.customColor),
                            subtitle: Text(l.customColorDesc),
                            value: seedColorState.useCustom,
                            onChanged: (v) =>
                                ref.read(seedColorProvider.notifier).setUseCustom(v),
                          ),
                          if (seedColorState.useCustom) ...[
                            ListTile(
                              leading: const Icon(Icons.circle, size: 24),
                              title: Text(l.colorScheme),
                              subtitle: Text(seedColorState.customArgb != null
                                  ? l.colorCustom
                                  : l.selectColor),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: seedColorState.color,
                                    radius: 12,
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              onTap: () => _pickColor(context, ref, seedColorState),
                            ),
                          ],
                          SwitchListTile(
                            secondary: const Icon(Icons.vibration),
                            title: Text(l.hapticFeedback),
                            subtitle: Text(l.hapticFeedbackDesc),
                            value: hapticEnabled,
                            onChanged: (v) =>
                                ref.read(hapticProvider.notifier).toggle(v),
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
                      ),
                      SectionHeader(title: l.sectionData),
                      _DataSection(),
                      SectionHeader(title: l.sectionTips),
                      _GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.volunteer_activism),
                            title: Text(l.tipProgram),
                            subtitle: Text(l.tipBadgesNone),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => const TipsPage(),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.red),
                            title: Text(l.moreDonate),
                            subtitle: Text(l.moreDonateSubtitle),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, _sponsorsUrl),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView(
                    children: [
                      SectionHeader(title: l.sectionFeedbackCommunity),
                      _GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.rate_review),
                            title: Text(l.moreFeedback),
                            subtitle: Text(l.moreFeedbackSubtitle),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/feedback'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.code),
                            title: Text(l.moreSource),
                            subtitle: Text(l.moreSourceSubtitle),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, _repoUrl),
                          ),
                          ListTile(
                            leading: const Icon(Icons.menu_book),
                            title: Text(l.moreDocs),
                            subtitle: Text(l.moreDocsSubtitle),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, _docsUrl),
                          ),
                          ListTile(
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
                        ],
                      ),
                      SectionHeader(title: l.sectionAbout),
                      _GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(l.officialWebsite),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, _repoUrl),
                          ),
                          ListTile(
                            leading: const Icon(Icons.forum_outlined),
                            title: Text(l.communityForums),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(
                              context,
                              'https://github.com/abrahdev/karter/discussions',
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.translate),
                            title: Text(l.translations),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openUrl(context, _weblateUrl),
                          ),
                          ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined),
                            title: Text(l.privacyPolicy),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => const PrivacyPolicyPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _AboutInfoCard(l: l),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          l.moreFooter,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            SectionHeader(title: l.sectionPreferences),
            _GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: Text(l.theme),
                  subtitle: Text(themeLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showThemePicker(context, ref, themeMode),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.format_color_fill),
                  title: Text(l.colorOfInterface),
                  subtitle: Text(l.colorOfInterfaceDesc),
                  value: surfaceTint,
                  onChanged: (v) =>
                      ref.read(surfaceTintProvider.notifier).toggle(v),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.palette_outlined),
                  title: Text(l.customColor),
                  subtitle: Text(l.customColorDesc),
                  value: seedColorState.useCustom,
                  onChanged: (v) =>
                      ref.read(seedColorProvider.notifier).setUseCustom(v),
                ),
                if (seedColorState.useCustom) ...[
                  ListTile(
                    leading: const Icon(Icons.circle, size: 24),
                    title: Text(l.colorScheme),
                    subtitle: Text(seedColorState.customArgb != null
                        ? l.colorCustom
                        : l.selectColor),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: seedColorState.color,
                          radius: 12,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () => _pickColor(context, ref, seedColorState),
                  ),
                ],
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: Text(l.hapticFeedback),
                  subtitle: Text(l.hapticFeedbackDesc),
                  value: hapticEnabled,
                  onChanged: (v) =>
                      ref.read(hapticProvider.notifier).toggle(v),
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
            ),

            SectionHeader(title: l.sectionData),
            _DataSection(),

            SectionHeader(title: l.sectionFeedbackCommunity),
            _GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.rate_review),
                  title: Text(l.moreFeedback),
                  subtitle: Text(l.moreFeedbackSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/feedback'),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(l.moreSource),
                  subtitle: Text(l.moreSourceSubtitle),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(context, _repoUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(l.moreDocs),
                  subtitle: Text(l.moreDocsSubtitle),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(context, _docsUrl),
                ),
                ListTile(
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
              ],
            ),

            SectionHeader(title: l.sectionTips),
            _GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.volunteer_activism),
                  title: Text(l.tipProgram),
                  subtitle: Text(l.tipBadgesNone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => const TipsPage(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.red),
                  title: Text(l.moreDonate),
                  subtitle: Text(l.moreDonateSubtitle),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(context, _sponsorsUrl),
                ),
              ],
            ),

            SectionHeader(title: l.sectionAbout),
            _GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l.officialWebsite),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(context, _repoUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.forum_outlined),
                  title: Text(l.communityForums),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(
                    context,
                    'https://github.com/abrahdev/karter/discussions',
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(l.translations),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openUrl(context, _weblateUrl),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => const PrivacyPolicyPage(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _AboutInfoCard(l: l),

            const SizedBox(height: 24),
            Center(
              child: Text(
                l.moreFooter,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        );
      },
    );

    return narrow;
  }

  String _languageLabel(LocaleNotifier notifier, AppLocalizations l) {
    if (notifier.isSystem) return l.languageSystem;
    return l.english;
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

  Future<void> _pickColor(
    BuildContext context,
    WidgetRef ref,
    SeedColorState current,
  ) async {
    final l = AppLocalizations.of(context)!;
    Color picked = current.color;

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
          if (current.customArgb != null)
            TextButton(
              onPressed: () => Navigator.pop(ctx, Colors.amber),
              child: Text(l.resetToDefault),
            ),
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
      if (color == Colors.amber) {
        await ref.read(seedColorProvider.notifier).resetColor();
      } else {
        await ref.read(seedColorProvider.notifier).setColor(color);
      }
    }
  }
}

class _AboutInfoCard extends ConsumerWidget {
  final AppLocalizations l;
  const _AboutInfoCard({required this.l});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final version = info != null
            ? '${info.version}+${info.buildNumber}'
            : '...';
        final deviceId = _deviceId();

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l.version),
                  subtitle: Text(version),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(l.deviceId),
                  subtitle: Text(deviceId),
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l.changelog),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    builder: (_) => const ChangelogSheet(),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(l.openSourceLicenses),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Karter',
                  ),
                ),
              ],
            ).toList(),
          ),
        );
      },
    );
  }

  static String _deviceId() {
    final bytes = utf8.encode('karter-device');
    var hash = 0x811c9dc5;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16).toUpperCase().padLeft(8, '0') * 4;
  }
}

class _GroupedCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupedCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ListTile.divideTiles(
          context: context,
          tiles: children,
        ).toList(),
      ),
    );
  }
}

class _DataSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final config = ref.watch(templateSourceProvider);

    final tiles = <Widget>[
      ListTile(
        leading: const Icon(Icons.storage),
        title: Text(l.moreExport),
        subtitle: Text(l.moreExportSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/data'),
      ),
      SwitchListTile(
        secondary: Icon(config.enabled ? Icons.cloud : Icons.cloud_off),
        title: Text(l.moreTemplateSource),
        subtitle: Text(l.moreTemplateSourceSubtitle),
        value: config.enabled,
        onChanged: (v) =>
            ref.read(templateSourceProvider.notifier).setEnabled(v),
      ),
    ];

    if (config.enabled) {
      tiles.add(
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(l.moreTemplateSourceUrl),
          subtitle: Text(
            config.repoUrl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: const Icon(Icons.edit),
          onTap: () => _editUrl(context, ref, config.repoUrl),
        ),
      );
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList(),
      ),
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


