import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/widgets/notification_settings_modal.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  void _showContextMenu(BuildContext context, RelativeRect position) async {
    final l = AppLocalizations.of(context)!;
    final result = await showMenu<String>(
      context: context,
      position: position,
      items: [
        PopupMenuItem(value: 'edit', child: Text(l.edit)),
        PopupMenuItem(value: 'dashboard', child: Text(l.addToDashboard)),
        PopupMenuItem(value: 'notifications', child: Text(l.setupNotifications)),
      ],
    );

    if (!context.mounted || result == null) return;

    switch (result) {
      case 'edit':
        context.push('/vehicle/${vehicle.id}/edit');
      case 'dashboard':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.addToDashboardComingSoon)),
        );
      case 'notifications':
        showNotificationSettingsModal(context, vehicleId: vehicle.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l = AppLocalizations.of(context)!;
    final distance = vehicle.currentOdometer.distance;
    final isKm = vehicle.currentOdometer.unit.name == 'kilometers';
    final distanceText =
        '${distance.toStringAsFixed(0)} ${isKm ? l.unitKm : l.unitMi}';
    final hasAlias =
        vehicle.alias != null && vehicle.alias!.isNotEmpty;

    return GestureDetector(
      onLongPressStart: (details) {
        final position = RelativeRect.fromRect(
          Rect.fromCenter(
            center: details.globalPosition,
            width: 200,
            height: 0,
          ),
          Offset.zero & MediaQuery.of(context).size,
        );
        _showContextMenu(context, position);
      },
      onSecondaryTapUp: (details) {
        final position = RelativeRect.fromRect(
          Rect.fromCenter(
            center: details.globalPosition,
            width: 200,
            height: 0,
          ),
          Offset.zero & MediaQuery.of(context).size,
        );
        _showContextMenu(context, position);
      },
      child: Card(
        child: Semantics(
          button: true,
          label: vehicle.displayName,
          child: ListTile(
            leading: Hero(
              tag: 'vehicle-avatar-${vehicle.id}',
              child: CircleAvatar(
                backgroundColor: cs.primaryContainer,
                child: Icon(
                  switch (vehicle.type) {
                    VehicleType.combustion => Icons.local_gas_station,
                    VehicleType.electric => Icons.electric_car,
                    VehicleType.motorcycle => Icons.motorcycle,
                  },
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
            title: Text(vehicle.displayName),
            subtitle: Text(
              hasAlias
                  ? '${vehicle.brand} ${vehicle.model} ${vehicle.year}'
                  : distanceText,
            ),
            trailing: hasAlias
                ? Text(
                    distanceText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  )
                : Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
