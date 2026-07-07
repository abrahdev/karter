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
    return Card(
      child: ListTile(
        leading: Hero(
          tag: 'vehicle-avatar-${vehicle.id}',
          child: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(
              switch (vehicle.type) {
                VehicleType.combustion => Icons.local_gas_station,
                VehicleType.electric => Icons.electric_car,
                VehicleType.motorcycle => Icons.motorcycle,
              },
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(vehicle.displayName),
        subtitle: Text(
          vehicle.alias != null && vehicle.alias!.isNotEmpty
              ? '${vehicle.brand} ${vehicle.model} ${vehicle.year}'
              : '${vehicle.currentOdometer.distance.toStringAsFixed(0)} ${vehicle.currentOdometer.unit.name == 'kilometers' ? 'km' : 'mi'}',
        ),
        trailing: Text(
          '${vehicle.currentOdometer.distance.toStringAsFixed(0)} ${vehicle.currentOdometer.unit.name == 'kilometers' ? 'km' : 'mi'}',
          style: theme.textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }
}
