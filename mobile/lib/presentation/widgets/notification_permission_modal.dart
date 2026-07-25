import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showNotificationPermissionModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const NotificationPermissionModal(),
  );
}

class NotificationPermissionModal extends ConsumerStatefulWidget {
  const NotificationPermissionModal({super.key});

  @override
  ConsumerState<NotificationPermissionModal> createState() =>
      _NotificationPermissionModalState();
}

class _NotificationPermissionModalState
    extends ConsumerState<NotificationPermissionModal> {
  bool _enabled = true;
  bool _loading = true;
  bool _denied = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final service = ref.read(notificationServiceProvider);
    final enabled = await service.areNotificationsEnabled();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _loading = false;
    });
  }

  Future<void> _requestPermission() async {
    final service = ref.read(notificationServiceProvider);
    final granted = await service.requestNotificationPermission();
    if (!mounted) return;
    if (granted == true) {
      Navigator.of(context).pop();
    } else {
      setState(() => _denied = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (_loading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 32),
          CircularProgressIndicator(),
          SizedBox(height: 32),
        ],
      );
    }

    if (_enabled) return const SizedBox.shrink();

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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _denied
                    ? Icons.notifications_off_outlined
                    : Icons.notifications_none_outlined,
                size: 48,
                color: cs.primary,
              ),
              const SizedBox(height: 16),
              Text(
                _denied
                    ? l.notificationsPermissionDeniedTitle
                    : l.notificationsPermissionTitle,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _denied
                    ? l.notificationsPermissionDeniedDesc
                    : l.notificationsPermissionDesc,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              if (_denied) ...[
                const SizedBox(height: 16),
                Card(
                  color: cs.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l.notificationsPermissionDeniedStep1, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(l.notificationsPermissionDeniedStep2, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(l.notificationsPermissionDeniedStep3, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(l.notificationsPermissionDeniedStep4, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (_denied)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('package:dev.abrah.karter');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.settings),
                    label: Text(l.notificationsPermissionOpenSettings),
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _requestPermission,
                    child: Text(l.notificationsPermissionAllow),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
