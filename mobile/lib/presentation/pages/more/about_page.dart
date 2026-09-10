import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/rating_helper.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/template_source_provider.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/section_header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  static const _repoUrl = 'https://github.com/abrahdev/karter';
  static const _weblateUrl = 'https://hosted.weblate.org/engage/karter/';
  static const _sponsorsUrl = 'https://github.com/sponsors/abrahdev';
  static const _deviceIdKey = 'device_id';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.moreAbout)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/branding/karter-icon-1024.png',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.moreAbout,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.moreDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GroupedCard(
            children: [
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: Text(l.moreRate),
                subtitle: Text(l.moreRateSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showPlayStoreRating(context),
              ),
            ],
          ),
          SectionHeader(title: l.version),
          GroupedCard(
            children: [
              _VersionTile(),
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: Text(l.deviceId),
                subtitle: Text(_deviceId(ref)),
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
          SectionHeader(title: l.communityForums),
          GroupedCard(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l.officialWebsite),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _openUrl(context, _repoUrl),
              ),
              ListTile(
                leading: const Icon(Icons.translate),
                title: Text(l.translations),
                trailing: const Icon(Icons.open_in_new),
                onTap: () => _openUrl(context, _weblateUrl),
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
            ],
          ),
        ],
      ),
    );
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

  String _deviceId(WidgetRef ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final existing = prefs.getString(_deviceIdKey);
    if (existing != null) return existing;
    final id = const Uuid().v4();
    prefs.setString(_deviceIdKey, id);
    return id;
  }
}

class _VersionTile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final version = info != null
            ? '${info.version}+${info.buildNumber}'
            : '...';
        return ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(AppLocalizations.of(context)!.version),
          subtitle: Text(version),
        );
      },
    );
  }
}