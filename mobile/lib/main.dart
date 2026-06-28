import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/presentation/pages/fuel_log_form_page.dart';
import 'package:mobile/presentation/pages/fuel_log_list_page.dart';
import 'package:mobile/presentation/pages/home_page.dart';
import 'package:mobile/presentation/pages/maintenance_log_form_page.dart';
import 'package:mobile/presentation/pages/maintenance_log_list_page.dart';
import 'package:mobile/presentation/pages/maintenance_settings_page.dart';
import 'package:mobile/presentation/pages/vehicle_detail_page.dart';
import 'package:mobile/presentation/pages/vehicle_form_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/vehicle/new',
      builder: (_, __) => const VehicleFormPage(),
    ),
    GoRoute(
      path: '/vehicle/:id',
      builder: (_, state) => VehicleDetailPage(
        vehicleId: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (_, state) => VehicleFormPage(
            vehicleId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'fuel',
          builder: (_, state) => FuelLogListPage(
            vehicleId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, state) => FuelLogFormPage(
                vehicleId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'maintenance',
          builder: (_, state) => MaintenanceLogListPage(
            vehicleId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              path: 'new',
              builder: (_, state) {
            final extra = state.extra;
            String? description;
            String? intervalId;
            if (extra is Map<String, String>) {
              description = extra['description'];
              intervalId = extra['intervalId'];
            }
            return MaintenanceLogFormPage(
              vehicleId: state.pathParameters['id']!,
              initialDescription: description,
              initialIntervalId: intervalId,
            );
          },
            ),
            GoRoute(
              path: 'settings',
              builder: (_, state) => MaintenanceSettingsPage(
                vehicleId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

class KarterApp extends StatelessWidget {
  const KarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Karter',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() {
  runApp(
    const ProviderScope(child: KarterApp()),
  );
}
