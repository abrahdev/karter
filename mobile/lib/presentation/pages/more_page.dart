import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' show BlockPicker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/catalog_service.dart';
import 'package:mobile/data/services/catalog_source.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/pages/changelog_page.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/providers/backup_provider.dart';
import 'package:mobile/presentation/providers/catalog_sources_provider.dart';
import 'package:mobile/presentation/providers/color_provider.dart';
import 'package:mobile/presentation/providers/haptic_provider.dart';
import 'package:mobile/presentation/providers/shake_to_odometer_provider.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/surface_tint_provider.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/providers/theme_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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
                      GroupedCard(
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
                      SectionHeader(title: l.sectionTemplates),
                      GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.grid_view_outlined),
                            title: Text(l.templatesTitle),
                            subtitle: Text(l.templatesSubtitle),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/templates'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.add_circle_outline),
                            title: Text(l.createTemplate),
                            subtitle: Text(l.createTemplateSubtitle),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/templates/create'),
                          ),
                        ],
                      ),
                      SectionHeader(title: l.sectionTips),
                      GroupedCard(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.volunteer_activism),
                            title: Text(l.tipProgram),
                            subtitle: Text(l.tipBadgesNone),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/tips'),
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
                      GroupedCard(
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
                            onTap: () => context.push('/onboarding'),
                          ),
                        ],
                      ),
                      SectionHeader(title: l.sectionAbout),
                      GroupedCard(
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
                            onTap: () => context.push('/privacy'),
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
            GroupedCard(
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

            SectionHeader(title: l.sectionTemplates),
            GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.grid_view_outlined),
                  title: Text(l.templatesTitle),
                  subtitle: Text(l.templatesSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/templates'),
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline),
                  title: Text(l.createTemplate),
                  subtitle: Text(l.createTemplateSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/templates/create'),
                ),
              ],
            ),

            SectionHeader(title: l.sectionFeedbackCommunity),
            GroupedCard(
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
                  onTap: () => context.push('/onboarding'),
                ),
              ],
            ),

            SectionHeader(title: l.sectionTips),
            GroupedCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.volunteer_activism),
                  title: Text(l.tipProgram),
                  subtitle: Text(l.tipBadgesNone),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/tips'),
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
            GroupedCard(
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
                  onTap: () => context.push('/privacy'),
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

  static const _deviceIdKey = 'device_id';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final version = info != null
            ? '${info.version}+${info.buildNumber}'
            : '...';
        final deviceId = _deviceId(ref);

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
                  onTap: () => karterShowModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
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

  static String _deviceId(WidgetRef ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null) return existing;
    final id = const Uuid().v4();
    prefs.setString(_deviceIdKey, id);
    return id;
  }
}

class _DataSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final config = ref.watch(templateSourceProvider);
    final activeSource = ref.watch(catalogSourcesProvider).active;

    final tiles = <Widget>[
      ListTile(
        leading: const Icon(Icons.dataset_outlined),
        title: Text(l.catalogDb),
        subtitle: Text(
          activeSource != null
              ? catalogSourceLabel(l, activeSource)
              : l.catalogSourceBuiltin,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openCatalogSourcesSheet(context),
      ),
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
      final versionLabel = config.version.isEmpty
          ? l.moreTemplateSourceVersionLatest
          : config.version;
      final testUrl = config.version.isEmpty || !config.repoUrl.contains('<tag>')
          ? config.repoUrl
          : config.repoUrl.replaceAll('<tag>', config.version);

      tiles.add(
        ListTile(
          leading: const Icon(Icons.link),
          title: Text(l.moreTemplateSourceUrl),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.repoUrl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                versionLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TestCatalogButton(url: testUrl),
              const Icon(Icons.edit),
            ],
          ),
          onTap: () => _editUrl(context, ref, config.repoUrl, config.version),
        ),
      );
    }

    return GroupedCard(children: tiles);
  }

  Future<void> _editUrl(
      BuildContext context, WidgetRef ref, String currentUrl, String currentVersion) async {
    final l = AppLocalizations.of(context)!;

    final result = await karterShowModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditTemplateSourceSheet(
        initialUrl: currentUrl,
        initialVersion: currentVersion,
      ),
    );

    if (result != null && result.$1.isNotEmpty) {
      await ref.read(templateSourceProvider.notifier).setRepoUrl(result.$1);
      await ref.read(templateSourceProvider.notifier).setVersion(result.$2);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.moreTemplateSourceUrlSaved)),
        );
      }
    }
  }

  void _openBackupSheet(BuildContext context, WidgetRef ref) {
    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _BackupSheet(),
    );
  }

  void _openCatalogSourcesSheet(BuildContext context) {
    karterShowModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _CatalogSourcesSheet(),
    );
  }
}

String catalogSourceLabel(AppLocalizations l, CatalogSource source) {
  return switch (source.kind) {
    CatalogSourceKind.builtin => l.catalogSourceBuiltin,
    CatalogSourceKind.online => l.catalogSourceOnline,
    CatalogSourceKind.local => source.name,
  };
}

IconData catalogSourceIcon(CatalogSource source) {
  return switch (source.kind) {
    CatalogSourceKind.builtin => Icons.archive_outlined,
    CatalogSourceKind.online => Icons.cloud_outlined,
    CatalogSourceKind.local => Icons.file_present_outlined,
  };
}

class _CatalogSourcesSheet extends ConsumerStatefulWidget {
  const _CatalogSourcesSheet();

  @override
  ConsumerState<_CatalogSourcesSheet> createState() =>
      _CatalogSourcesSheetState();
}

class _CatalogSourcesSheetState extends ConsumerState<_CatalogSourcesSheet> {
  bool _importing = false;
  bool _refreshing = false;
  String? _version;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final version = await ref.read(catalogServiceProvider).catalogVersion();
    if (mounted) setState(() => _version = version);
  }

  Future<void> _select(CatalogSource source) async {
    try {
      await ref.read(catalogSourcesProvider.notifier).select(source.id);
      await _loadVersion();
    } catch (_) {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            source.isOnline ? l.catalogOnlineUnavailable : l.catalogNotAvailable,
          ),
        ),
      );
    }
  }

  Future<void> _refreshOnline() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _refreshing = true);
    try {
      await ref.read(catalogSourcesProvider.notifier).refreshOnline();
      await _loadVersion();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogRefreshed)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogRefreshFailed)),
      );
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _import() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _importing = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['db'],
      );
      if (result.isEmpty || result.first.path == null) return;
      final path = result.first.path!;
      await ref.read(catalogSourcesProvider.notifier).importLocal(path);
      await _loadVersion();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogImported)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogImportFailed)),
      );
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  Future<void> _delete(CatalogSource source) async {
    final l = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.catalogDelete),
        content: Text(l.catalogDeleteConfirm(source.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: Text(l.catalogDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(catalogSourcesProvider.notifier).deleteSource(source.id);
    await _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(catalogSourcesProvider);
    final active = state.active;
    final config = ref.watch(templateSourceProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(l.catalogDb, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      active != null
                          ? catalogSourceIcon(active)
                          : Icons.archive_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            active != null
                                ? catalogSourceLabel(l, active)
                                : l.catalogSourceBuiltin,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _version != null
                                ? l.catalogDbVersion(_version!)
                                : l.catalogVersionUnknown,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (active?.isOnline ?? false) ...[
                            const SizedBox(height: 2),
                            Text(
                              l.templateSourceRelease(
                                config.version.isEmpty
                                    ? l.moreTemplateSourceVersionLatest
                                    : config.version,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (active?.isOnline ?? false)
                      IconButton(
                        tooltip: l.catalogRefreshOnline,
                        onPressed: _refreshing ? null : _refreshOnline,
                        icon: _refreshing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.5),
                              )
                            : const Icon(Icons.refresh),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(l.catalogSourcesTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            for (final source in state.sources)
              ListTile(
                leading: Icon(catalogSourceIcon(source)),
                title: Text(catalogSourceLabel(l, source)),
                subtitle: source.isOnline
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            config.repoUrl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            config.version.isEmpty
                                ? l.moreTemplateSourceVersionLatest
                                : config.version,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      )
                    : source.isBuiltin
                        ? Text(
                            l.catalogCannotDelete,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                selected: source.id == state.activeId,
                trailing: source.deletable
                    ? IconButton(
                        tooltip: l.catalogDelete,
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _delete(source),
                      )
                    : (source.id == state.activeId
                        ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                        : null),
                onTap: source.id == state.activeId
                    ? null
                    : () => _select(source),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _importing ? null : _import,
                icon: _importing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Icon(Icons.upload_file_outlined),
                label: Text(l.catalogImportDb),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EditTemplateSourceSheet extends ConsumerStatefulWidget {
  const _EditTemplateSourceSheet({
    required this.initialUrl,
    required this.initialVersion,
  });

  final String initialUrl;
  final String initialVersion;

  @override
  ConsumerState<_EditTemplateSourceSheet> createState() =>
      _EditTemplateSourceSheetState();
}

class _EditTemplateSourceSheetState
    extends ConsumerState<_EditTemplateSourceSheet> {
  static const _latestSentinel = '';

  late final TextEditingController _controller;
  Timer? _debounce;
  bool _testing = false;
  bool _loadingVersions = false;
  bool _versionsFailed = false;
  List<String> _tags = const [];
  String _selectedTag = _latestSentinel;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialUrl);
    _selectedTag = widget.initialVersion;
    _scheduleRefresh();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) => _scheduleRefresh();

  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _refresh();
    });
  }

  Future<void> _refresh() async {
    final url = _controller.text.trim();
    final parsed = CatalogService.parseOwnerRepo(url);
    final hasTag = url.contains('<tag>');

    if (!hasTag || parsed == null) {
      if (_tags.isNotEmpty || _loadingVersions || _versionsFailed) {
        setState(() {
          _tags = const [];
          _selectedTag = _latestSentinel;
          _versionsFailed = false;
          _loadingVersions = false;
        });
      }
      return;
    }

    setState(() {
      _loadingVersions = true;
      _versionsFailed = false;
    });

    final latest = await CatalogService.latestReleaseRef(
      owner: parsed.$1,
      repo: parsed.$2,
    );
    final tags = await CatalogService.listTags(
      owner: parsed.$1,
      repo: parsed.$2,
    );
    if (!mounted) return;

    setState(() {
      _loadingVersions = false;
      _tags = tags;
      _versionsFailed = tags.isEmpty && latest == null;
      if (_selectedTag != _latestSentinel && !tags.contains(_selectedTag)) {
        _selectedTag = _latestSentinel;
      }
    });
  }

  void _onVersionSelected(String value) {
    setState(() {
      _selectedTag = value;
    });
  }

  String _urlToTest() {
    final raw = _controller.text.trim();
    if (_selectedTag != _latestSentinel && raw.contains('<tag>')) {
      return raw.replaceAll('<tag>', _selectedTag);
    }
    return raw;
  }

  Future<void> _test() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _testing = true);
    try {
      final check =
          await ref.read(catalogServiceProvider).checkImport(_urlToTest());
      if (!mounted) return;
      setState(() => _testing = false);
      await karterShowModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _CatalogCheckSheet(check: check),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _testing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.catalogNotAvailable)),
      );
    }
  }

  void _reset(BuildContext context) {
    ref.read(templateSourceProvider.notifier).resetToDefault();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final hasTag = _controller.text.contains('<tag>');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(l.moreTemplateSourceEditUrl,
                        style: theme.textTheme.titleMedium),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    tooltip: l.templateUrlHelp,
                    onPressed: () => karterShowModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const _TemplateSourceHelpSheet(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  labelText: l.moreTemplateSourceUrlLabel,
                  hintText: l.moreTemplateSourceUrlHint,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _reset(context),
                  icon: const Icon(Icons.restore),
                  label: Text(l.moreTemplateSourceReset),
                ),
              ),
              if (hasTag) ...[
                const SizedBox(height: 16),
                if (_loadingVersions)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  ),
                if (!_loadingVersions && _versionsFailed)
                  Text(
                    l.templateUrlVersionsFailed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                if (!_loadingVersions && _tags.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTag,
                    decoration: InputDecoration(
                      labelText: l.templateUrlVersion,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: _latestSentinel,
                        child: Text(l.templateUrlLatest),
                      ),
                      for (final tag in _tags)
                        DropdownMenuItem<String>(
                          value: tag,
                          child: Text(tag),
                        ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        _onVersionSelected(v);
                      }
                    },
                  ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _testing ? null : _test,
                  icon: _testing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        )
                      : const Icon(Icons.play_circle_outline),
                  label: Text(l.testConnection),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final url = _controller.text.trim();
                    if (url.isNotEmpty) {
                      Navigator.pop(context, (url, _selectedTag));
                    }
                  },
                  child: Text(l.saveChangesShort),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateSourceHelpSheet extends StatelessWidget {
  const _TemplateSourceHelpSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(l.templateUrlHelp, style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(
                l.templateUrlExample,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
              Text(
                l.templateUrlTagExplanation,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.templateUrlUsage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TestCatalogButton extends ConsumerStatefulWidget {
  const _TestCatalogButton({required this.url});

  final String url;

  @override
  ConsumerState<_TestCatalogButton> createState() => _TestCatalogButtonState();
}

class _TestCatalogButtonState extends ConsumerState<_TestCatalogButton> {
  bool _loading = false;

  Future<void> _run() async {
    setState(() => _loading = true);
    final check =
        await ref.read(catalogServiceProvider).checkImport(widget.url);
    if (!mounted) return;
    setState(() => _loading = false);
    await karterShowModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CatalogCheckSheet(check: check),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.play_circle_outline),
      tooltip: AppLocalizations.of(context)!.testConnection,
      onPressed: _run,
    );
  }
}

class _CatalogCheckSheet extends StatelessWidget {
  const _CatalogCheckSheet({required this.check});

  final CatalogImportCheck check;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final okColor = theme.colorScheme.primary;
    final errColor = theme.colorScheme.error;

    Widget statusRow(bool ok, String text, {String? detail}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              ok ? Icons.check_circle : Icons.error_outline,
              color: ok ? okColor : errColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: theme.textTheme.bodyMedium),
                  if (detail != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        detail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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

    Widget section(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          title,
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.primary),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            children: [
              Text(l.testConnection, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                check.baseUrl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              section(l.importCheckTranslations),
              statusRow(
                check.translationsOk,
                l.importCheckTranslationsResult(
                  check.translationsFound,
                  check.translationsTotal,
                ),
              ),
              section(l.importCheckIndex),
              statusRow(
                check.indexOk,
                l.importCheckIndexResult(check.templateCount),
              ),
              section(l.importCheckDb),
              statusRow(
                check.dbRemoteFound,
                check.dbRemoteFound
                    ? l.importCheckDbRemoteFound
                    : l.importCheckDbRemoteNotFound,
                detail: check.dbRemoteFound && check.dbRemoteModified != null
                    ? l.catalogDbModifiedAt(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(check.dbRemoteModified!.toLocal()),
                      )
                    : null,
              ),
              if (check.dbRemoteFound) ...[
                section(l.importCheckDbLocal),
                if (check.localDbOk) ...[
                  if (check.catalogVersion != null)
                    statusRow(true,
                        l.importCheckCatalogVersion(check.catalogVersion!)),
                  statusRow(true, l.importCheckVehicles(check.vehicles)),
                  statusRow(
                      true, l.importCheckMaintenanceItems(check.maintenanceItems)),
                  statusRow(true, l.importCheckParts(check.parts)),
                  statusRow(true, l.importCheckObdCodes(check.obdCodes)),
                ] else
                  statusRow(false, l.importCheckDbLocalFailed),
              ],
            ],
          ),
        ),
      ],
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
                      ? const M3LoadingIndicator(size: 16)
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

              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.storage, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.backupCount(state.driveBackups.length.toString(), state.maxBackups.toString()),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: state.maxBackups > 1
                            ? () => notifier.setMaxBackups(state.maxBackups - 1)
                            : null,
                      ),
                      Text(
                        '${state.maxBackups}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: state.maxBackups < 50
                            ? () => notifier.setMaxBackups(state.maxBackups + 1)
                            : null,
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
                      ? const M3LoadingIndicator(size: 16)
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
                      ? const M3LoadingIndicator(size: 16)
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

    notifier.listBackups();

    if (!context.mounted) return;

    final selected = await karterShowModalBottomSheet<String>(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(backupProvider);
          final notifier = ref.read(backupProvider.notifier);

          if (state.loading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: M3LoadingIndicator(
                  contained: true,
                  size: 36,
                  containerSize: 72,
                ),
              ),
            );
          }

          if (state.driveBackups.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.backupNoBackups),
              ),
            );
          }

          return ListView(
            children: state.driveBackups.map((b) {
              return ListTile(
                leading: const Icon(Icons.cloud),
                title: Text(
                  b.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_formatSize(b.sizeBytes)} · ${DateFormat.yMMMd().add_jm().format(b.modifiedAt.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l.backupDelete),
                        content: Text(l.backupDeleteConfirm(b.name)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(l.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                            ),
                            child: Text(l.backupDelete),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await notifier.deleteBackup(b.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.backupDeleteSuccess)),
                        );
                      }
                    }
                  },
                ),
                onTap: () => Navigator.pop(ctx, b.id),
              );
            }).toList(),
          );
        },
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

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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


