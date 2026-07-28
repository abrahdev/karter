import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show BlockPicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/changelog_page.dart';
import 'package:mobile/presentation/pages/onboarding_page.dart';
import 'package:mobile/presentation/pages/privacy_policy_page.dart';
import 'package:mobile/presentation/pages/tips_page.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:mobile/presentation/providers/backup_provider.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/shake_to_odometer_provider.dart';
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
    final hapticMode = ref.watch(hapticProvider);
    final shakeToOdometerEnabled = ref.watch(shakeToOdometerProvider);
    final surfaceTint = ref.watch(surfaceTintProvider);
    final localeNotifier = ref.watch(localeProvider.notifier);

    final themeLabel = switch (themeMode) {
      ThemeMode.light => l.themeLight,
      ThemeMode.dark => l.themeDark,
      ThemeMode.system => l.themeSystem,
    };

    final languageLabel = _languageLabel(localeNotifier, l, ref);

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
                          KarterSwitchListTile(
                            leading: const Icon(Icons.format_color_fill),
                            title: Text(l.colorOfInterface),
                            subtitle: Text(l.colorOfInterfaceDesc),
                            value: surfaceTint,
                            onChanged: (v) =>
                                ref.read(surfaceTintProvider.notifier).toggle(v),
                          ),
                          KarterSwitchListTile(
                            leading: const Icon(Icons.palette_outlined),
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
                          ExpansionTile(
                            leading: const Icon(Icons.vibration),
                            title: Text(l.hapticFeedback),
                            subtitle: Text(l.hapticFeedbackDesc),
                            children: [
                              RadioGroup<HapticMode>(
                                groupValue: hapticMode,
                                onChanged: (v) {
                                  ref
                                      .read(hapticProvider.notifier)
                                      .setMode(v!);
                                  _demoHaptic(v);
                                },
                                child: Column(
                                  children: [
                                    RadioListTile<HapticMode>(
                                      title: Text(l.hapticModeOff),
                                      subtitle: Text(l.hapticModeOffDesc),
                                      value: HapticMode.off,
                                    ),
                                    RadioListTile<HapticMode>(
                                      title: Text(l.hapticModeClear),
                                      subtitle: Text(l.hapticModeClearDesc),
                                      value: HapticMode.clear,
                                    ),
                                    RadioListTile<HapticMode>(
                                      title: Text(l.hapticModeRich),
                                      subtitle: Text(l.hapticModeRichDesc),
                                      value: HapticMode.rich,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          KarterSwitchListTile(
                            leading: const Icon(Icons.screen_rotation),
                            title: Text(l.shakeToOdometer),
                            subtitle: Text(l.shakeToOdometerDesc),
                            value: shakeToOdometerEnabled,
                            onChanged: (v) =>
                                ref.read(shakeToOdometerProvider.notifier).toggle(v),
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
                KarterSwitchListTile(
                  leading: const Icon(Icons.format_color_fill),
                  title: Text(l.colorOfInterface),
                  subtitle: Text(l.colorOfInterfaceDesc),
                  value: surfaceTint,
                  onChanged: (v) =>
                      ref.read(surfaceTintProvider.notifier).toggle(v),
                ),
                KarterSwitchListTile(
                  leading: const Icon(Icons.palette_outlined),
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
                ExpansionTile(
                  leading: const Icon(Icons.vibration),
                  title: Text(l.hapticFeedback),
                  subtitle: Text(l.hapticFeedbackDesc),
                  children: [
                    RadioGroup<HapticMode>(
                      groupValue: hapticMode,
                      onChanged: (v) {
                        ref
                            .read(hapticProvider.notifier)
                            .setMode(v!);
                        _demoHaptic(v);
                      },
                      child: Column(
                        children: [
                          RadioListTile<HapticMode>(
                            title: Text(l.hapticModeOff),
                            subtitle: Text(l.hapticModeOffDesc),
                            value: HapticMode.off,
                          ),
                          RadioListTile<HapticMode>(
                            title: Text(l.hapticModeClear),
                            subtitle: Text(l.hapticModeClearDesc),
                            value: HapticMode.clear,
                          ),
                          RadioListTile<HapticMode>(
                            title: Text(l.hapticModeRich),
                            subtitle: Text(l.hapticModeRichDesc),
                            value: HapticMode.rich,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                KarterSwitchListTile(
                  leading: const Icon(Icons.screen_rotation),
                  title: Text(l.shakeToOdometer),
                  subtitle: Text(l.shakeToOdometerDesc),
                  value: shakeToOdometerEnabled,
                  onChanged: (v) =>
                      ref.read(shakeToOdometerProvider.notifier).toggle(v),
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

  String _languageLabel(LocaleNotifier notifier, AppLocalizations l, WidgetRef ref) {
    if (notifier.isSystem) return l.languageSystem;
    final code = ref.read(localeProvider).languageCode;
    return switch (code) {
      'es' => l.spanish,
      'et' => l.eesti,
      _    => l.english,
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
      ListTile(
        leading: const Icon(Icons.cloud_upload_outlined),
        title: Text(l.moreBackup),
        subtitle: Text(l.moreBackupSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openBackupSheet(context, ref),
      ),
      KarterSwitchListTile(
        leading: Icon(config.enabled ? Icons.cloud : Icons.cloud_off),
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

  void _openBackupSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _BackupSheet(),
    );
  }
}

class _BackupSheet extends ConsumerStatefulWidget {
  const _BackupSheet();

  @override
  ConsumerState<_BackupSheet> createState() => _BackupSheetState();
}

class _BackupSheetState extends ConsumerState<_BackupSheet> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(backupProvider);
    final notifier = ref.read(backupProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l.moreBackup,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l.moreBackupSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (!state.signedIn)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.loading
                      ? null
                      : () => notifier.signIn(),
                  icon: state.loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud),
                  label: Text(l.backupConnect),
                ),
              )
            else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud_done, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.email ?? '',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              state.lastBackupAt != null
                                  ? l.backupLast(_formatDate(state.lastBackupAt!))
                                  : l.backupNever,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: state.backingUp
                      ? null
                      : () async {
                          await notifier.backupNow();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l.backupSuccess)),
                            );
                          }
                        },
                  icon: state.backingUp
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.backup),
                  label: Text(state.backingUp ? l.backupInProgress : l.backupNow),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: state.restoring
                      ? null
                      : () => _restore(context, notifier),
                  icon: state.restoring
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.restore),
                  label:
                      Text(state.restoring ? l.backupRestoreInProgress : l.backupRestore),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => notifier.signOut(),
                  icon: const Icon(Icons.logout),
                  label: Text(l.backupDisconnect),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _restore(BuildContext context, BackupNotifier notifier) async {
    final l = AppLocalizations.of(context)!;

    await notifier.listBackups();
    final state = ref.read(backupProvider);

    if (state.driveBackups.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.backupNoBackups)),
        );
      }
      return;
    }

    if (!context.mounted) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => ListView(
        children: state.driveBackups.map((b) {
          return ListTile(
            leading: const Icon(Icons.backup),
            title: Text(b.name),
            subtitle: Text(b.modifiedAt.toLocal().toString()),
            onTap: () => Navigator.pop(ctx, b.id),
          );
        }).toList(),
      ),
    );

    if (selected == null || !context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.backupRestore),
        content: Text(l.backupRestoreConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.backupRestoreBtn),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    await notifier.restoreBackup(selected);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.backupRestoreSuccess)),
      );
      Navigator.of(context).pop();
    }
  }

  String _formatDate(String isoDate) {
    final dt = DateTime.parse(isoDate);
    return DateFormat.yMMMd().add_jm().format(dt.toLocal());
  }
}

void _demoHaptic(HapticMode mode) {
  switch (mode) {
    case HapticMode.off:
      break;
    case HapticMode.clear:
      HapticFeedback.mediumImpact();
      break;
    case HapticMode.rich:
      HapticFeedback.mediumImpact();
      Future.delayed(
        const Duration(milliseconds: 60),
        () => HapticFeedback.lightImpact(),
      );
      break;
  }
}


