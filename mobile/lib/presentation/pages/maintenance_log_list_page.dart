import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:mobile/presentation/widgets/add_maintenance_log_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MaintenanceLogListPage extends ConsumerStatefulWidget {
  final String vehicleId;

  const MaintenanceLogListPage({super.key, required this.vehicleId});

  @override
  ConsumerState<MaintenanceLogListPage> createState() =>
      _MaintenanceLogListPageState();
}

class _MaintenanceLogListPageState
    extends ConsumerState<MaintenanceLogListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: DateTime(now.year, now.month, now.day - 1),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MaintenanceLog> _filterLogsByRange(List<MaintenanceLog> logs) {
    return logs.where((log) {
      return log.date.isAfter(
              _dateRange.start.subtract(const Duration(days: 1))) &&
          log.date.isBefore(
              _dateRange.end.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: _dateRange,
    );
    if (picked != null && mounted) {
      setState(() => _dateRange = picked);
    }
  }

  Future<void> _exportPdf() async {
    final l = AppLocalizations.of(context)!;

    final logs = await ref.read(
        maintenanceLogsProvider(widget.vehicleId).future);
    final filtered = _filterLogsByRange(logs);

    final vehicle = await ref.read(
        vehicleProvider(widget.vehicleId).future);
    final vehicleName = vehicle != null
        ? '${vehicle.brand} ${vehicle.model} ${vehicle.year}'
        : widget.vehicleId;

    final pdfService = ref.read(pdfExportServiceProvider);
    final pdfBytes = await pdfService.generateMaintenanceReport(
      vehicleName: vehicleName,
      logs: filtered,
      start: _dateRange.start,
      end: _dateRange.end,
      reportTitle: l.maintenanceReportTitle,
      generatedFooter: l.maintenanceReportGenerated('{date}', '{time}'),
      emptyMessage: l.maintenanceReportEmpty,
      servicesInPeriod: l.maintenanceServicesInPeriod(filtered.length),
      dateHeader: l.maintenanceReportDateHeader,
      descriptionHeader: l.maintenanceReportDescHeader,
      odometerHeader: l.maintenanceReportOdometerHeader,
      kmSuffix: l.km,
    );

    if (!mounted) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/karter-maintenance-report.pdf');
    await file.writeAsBytes(pdfBytes);

    try {
      await Share.shareXFiles([XFile(file.path)],
          text: '${l.maintenanceReportTitle} - $vehicleName');
    } catch (_) {
      if (Platform.isLinux) {
        await Process.run('xdg-open', [file.path]);
      } else {
        rethrow;
      }
    }
  }

  Widget _buildHistoryTab(List<MaintenanceLog> logs) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final dateFmt = DateFormat('dd/MM/yy');

    final sorted =
        List<MaintenanceLog>.from(logs)..sort((a, b) => b.date.compareTo(a.date));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...sorted.map((log) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      theme.colorScheme.secondaryContainer,
                  child: Icon(Icons.build,
                      color: theme
                          .colorScheme.onSecondaryContainer),
                ),
                title: Text(log.description),
                subtitle: Text(dateFmt.format(log.date)),
                trailing: log.odometerAtService > 0
                    ? Text(
                        '${log.odometerAtService.toStringAsFixed(0)} ${l.km}',
                        style: theme.textTheme.bodySmall)
                    : null,
                onTap: () => context.push(
                  '/vehicle/${widget.vehicleId}/maintenance/${log.id}',
                  extra: log,
                ),
              ),
            )),
        if (logs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.build,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l.maintenanceEmpty,
                      style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreviewTab(List<MaintenanceLog> logs) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final dateFmt = DateFormat('dd/MM/yy');
    final rangeFmt = DateFormat('dd/MM/yyyy');

    final filtered = _filterLogsByRange(logs);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.date_range),
            title: Text(
              '${rangeFmt.format(_dateRange.start)} - '
              '${rangeFmt.format(_dateRange.end)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: _pickDateRange,
          ),
        ),
        if (filtered.isNotEmpty) ...[
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.maintenanceServicesInPeriod(filtered.length),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(
                            color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  ...filtered.take(10).map((log) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                dateFmt.format(log.date),
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(
                                        color: theme
                                            .colorScheme.outline),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                log.description,
                                style:
                                    theme.textTheme.bodyMedium,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ),
                            if (log.odometerAtService > 0)
                              Text(
                                '${log.odometerAtService.toStringAsFixed(0)} ${l.km}',
                                style:
                                    theme.textTheme.bodySmall,
                              ),
                          ],
                        ),
                      )),
                  if (filtered.length > 10)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        l.maintenanceMoreServices(
                            filtered.length - 10),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(
                                color:
                                    theme.colorScheme.outline),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        if (logs.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _exportPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(l.maintenanceExportPdf),
            ),
          ),
        ],
        if (logs.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.build,
                      size: 64,
                      color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(l.maintenanceEmpty,
                      style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
        if (logs.isNotEmpty && filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off,
                      size: 64,
                      color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    l.maintenanceNoServicesInRange,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final logsAsync = ref.watch(maintenanceLogsProvider(widget.vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.maintenanceListTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l.maintenanceHistoryTab),
            Tab(text: l.maintenancePdfExportTab),
          ],
        ),
      ),
      body: logsAsync.when(
        data: (logs) => TabBarView(
          controller: _tabController,
          children: [
            _buildHistoryTab(logs),
            _buildPreviewTab(logs),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l.homeError(e.toString()))),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () => showAddMaintenanceLogModal(
                context,
                vehicleId: widget.vehicleId,
                onSaved: () {
                  ref.invalidate(
                      maintenanceLogsProvider(widget.vehicleId));
                  ref.invalidate(
                      maintenanceIntervalsProvider(
                          widget.vehicleId));
                },
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
