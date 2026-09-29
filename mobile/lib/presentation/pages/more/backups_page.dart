import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material3_indicators/material3_indicators.dart';
import 'package:mobile/core/modal_helpers.dart';
import 'package:mobile/core/theme/app_spacing.dart';
import 'package:mobile/data/services/backup_providers/backup_provider.dart';
import 'package:mobile/data/services/backup_providers/webdav_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/backup_provider.dart';
import 'package:mobile/presentation/widgets/grouped_card.dart';
import 'package:mobile/presentation/widgets/karter_segmented_button.dart';
import 'package:mobile/presentation/widgets/karter_switch_list_tile.dart';
import 'package:mobile/presentation/widgets/section_header.dart';

class BackupsPage extends ConsumerStatefulWidget {
  const BackupsPage({super.key});

  @override
  ConsumerState<BackupsPage> createState() => _BackupsPageState();
}

class _BackupsPageState extends ConsumerState<BackupsPage> {
  final _webDavUrlController = TextEditingController();
  final _webDavUserController = TextEditingController();
  final _webDavPasswordController = TextEditingController();
  bool _webDavPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(backupProvider);
    _webDavUrlController.text = state.webDavUrl ?? '';
    _webDavUserController.text = state.webDavUser ?? '';
  }

  @override
  void dispose() {
    _webDavUrlController.dispose();
    _webDavUserController.dispose();
    _webDavPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final state = ref.watch(backupProvider);
    final notifier = ref.read(backupProvider.notifier);

    ref.listen(backupProvider, (prev, next) {
      if (next.providerType == BackupProviderType.webDav &&
          !next.connected &&
          next.webDavUrl != null) {
        if (_webDavUrlController.text != next.webDavUrl) {
          _webDavUrlController.text = next.webDavUrl!;
        }
        if (_webDavUserController.text != next.webDavUser) {
          _webDavUserController.text = next.webDavUser!;
        }
      }
    });

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
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: theme.colorScheme.onErrorContainer),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(
                              color: theme.colorScheme.onErrorContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.backupProviderLabel,
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: KarterSegmentedButton<BackupProviderType>(
                      segments: const [
                        ButtonSegment(
                          value: BackupProviderType.googleDrive,
                          icon: Icon(Icons.cloud),
                          label: Text('Google Drive'),
                        ),
                        ButtonSegment(
                          value: BackupProviderType.webDav,
                          icon: Icon(Icons.dns_outlined),
                          label: Text('WebDAV'),
                        ),
                      ],
                      selected: {state.providerType},
                      onSelectionChanged: (v) =>
                          notifier.setProvider(v.first),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!state.connected)
                    _buildConnectSection(context, state, notifier)
                  else
                    _buildConnectedSection(context, state, notifier),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAutoBackupSection(context, state, notifier),
          const SizedBox(height: 16),
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

  Widget _buildConnectSection(
    BuildContext context,
    BackupState state,
    BackupNotifier notifier,
  ) {
    final l = AppLocalizations.of(context)!;
    if (state.providerType == BackupProviderType.googleDrive) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: state.loading ? null : () => notifier.connectGoogle(),
          icon: state.loading
              ? const M3LoadingIndicator(size: 16)
              : const Icon(Icons.cloud),
          label: Text(l.backupConnect),
        ),
      );
    }
    return _WebDavConnectForm(
      urlController: _webDavUrlController,
      userController: _webDavUserController,
      passwordController: _webDavPasswordController,
      passwordVisible: _webDavPasswordVisible,
      loading: state.loading,
      onTogglePassword: () =>
          setState(() => _webDavPasswordVisible = !_webDavPasswordVisible),
      onConnect: () => _connectWebDav(notifier),
    );
  }

  Future<void> _connectWebDav(BackupNotifier notifier) async {
    final config = WebDavConfig(
      url: _webDavUrlController.text,
      user: _webDavUserController.text,
      password: _webDavPasswordController.text,
    );
    await notifier.connectWebDav(config);
  }

  Widget _buildConnectedSection(
    BuildContext context,
    BackupState state,
    BackupNotifier notifier,
  ) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.cloud_done, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(state.account ?? '',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    state.lastBackupAt != null
                        ? l.backupLast(_formatDate(state.lastBackupAt!))
                        : l.backupNever,
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.storage, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.backupCount(state.backups.length.toString(),
                    state.maxBackups.toString()),
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
        const SizedBox(height: 12),
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
            label: Text(
                state.backingUp ? l.backupInProgress : l.backupNow),
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
            label: Text(state.restoring
                ? l.backupRestoreInProgress
                : l.backupRestore),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () => notifier.disconnect(),
            icon: const Icon(Icons.logout),
            label: Text(l.backupDisconnect),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoBackupSection(
    BuildContext context,
    BackupState state,
    BackupNotifier notifier,
  ) {
    final l = AppLocalizations.of(context)!;
    final isMobile = Platform.isAndroid || Platform.isIOS;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            KarterSwitchListTile(
              value: state.autoBackupEnabled,
              leading: const Icon(Icons.schedule),
              title: Text(l.backupAutoBackup),
              subtitle: Text(
                isMobile
                    ? l.backupAutoBackupSubtitle
                    : l.backupAutoBackupMobileOnly,
              ),
              onChanged: (state.connected && isMobile)
                  ? (v) => notifier.setAutoBackup(v)
                  : null,
            ),
            if (state.autoBackupEnabled) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.backupAutoBackupEvery(state.autoBackupHours),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    DropdownButton<int>(
                      value: state.autoBackupHours,
                      items: const [
                        DropdownMenuItem(value: 6, child: Text('6h')),
                        DropdownMenuItem(value: 12, child: Text('12h')),
                        DropdownMenuItem(value: 24, child: Text('24h')),
                        DropdownMenuItem(value: 168, child: Text('7d')),
                      ],
                      onChanged: (v) {
                        if (v != null) notifier.setAutoBackupHours(v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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

          if (state.backups.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.backupNoBackups),
              ),
            );
          }

          return ListView(
            children: state.backups.map((b) {
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
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
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

class _WebDavConnectForm extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onConnect;

  const _WebDavConnectForm({
    required this.urlController,
    required this.userController,
    required this.passwordController,
    required this.passwordVisible,
    required this.loading,
    required this.onTogglePassword,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: urlController,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l.backupWebDavUrl,
            hintText: l.backupWebDavUrlHint,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: userController,
          autocorrect: false,
          decoration: InputDecoration(labelText: l.backupWebDavUser),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: passwordController,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            labelText: l.backupWebDavPassword,
            suffixIcon: IconButton(
              icon: Icon(passwordVisible
                  ? Icons.visibility_off
                  : Icons.visibility),
              onPressed: onTogglePassword,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: loading ? null : onConnect,
          icon: loading
              ? const M3LoadingIndicator(size: 16)
              : const Icon(Icons.link),
          label: Text(l.backupWebDavConnect),
        ),
      ],
    );
  }
}