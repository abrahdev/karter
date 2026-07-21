import 'package:flutter/material.dart';
import 'package:mobile/domain/entities/vehicle.dart';
import 'package:mobile/domain/enums/vehicle_type.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final distance = vehicle.currentOdometer.distance;
    final isKm = vehicle.currentOdometer.unit.name == 'kilometers';
    final distanceText =
        '${distance.toStringAsFixed(0)} ${isKm ? 'km' : 'mi'}';
    final hasAlias =
        vehicle.alias != null && vehicle.alias!.isNotEmpty;

    return Card(
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
        trailing: Text(
          distanceText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
