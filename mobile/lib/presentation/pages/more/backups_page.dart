import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/backup_provider.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/section_header.dart';

class BackupsPage extends ConsumerStatefulWidget {
  const BackupsPage({super.key});

  @override
  ConsumerState<BackupsPage> createState() => _BackupsPageState();
}

class _BackupsPageState extends ConsumerState<BackupsPage> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(backupProvider);
    final notifier = ref.read(backupProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.moreBackup)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          SectionHeader(title: l.sectionBackup),
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
          SectionHeader(title: l.moreExport),
          GroupedCard(
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: Text(l.moreExport),
                subtitle: Text(l.moreExportSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/data'),
              ),
            ],
          ),
        ],
      ),
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