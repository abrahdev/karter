import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/presentation/pages/dashboard_page.dart';
import 'package:mobile/presentation/pages/data_manager_page.dart';
import 'package:mobile/presentation/pages/fuel_log_form_page.dart';
import 'package:mobile/presentation/pages/fuel_log_list_page.dart';
import 'package:mobile/presentation/pages/home_page.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/presentation/pages/maintenance_log_form_page.dart';
import 'package:mobile/presentation/pages/maintenance_log_list_page.dart';
import 'package:mobile/presentation/pages/maintenance_settings_page.dart';
import 'package:mobile/presentation/pages/more_page.dart';
import 'package:mobile/presentation/pages/vehicle_detail_page.dart';
import 'package:mobile/presentation/pages/vehicle_form_page.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (_, _, child) => _Shell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, _) => const DashboardPage(),
        ),
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/more',
          builder: (_, _) => const MorePage(),
        ),
      ],
    ),
    GoRoute(
      path: '/vehicle/new',
      builder: (_, _) => const VehicleFormPage(),
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
            GoRoute(
              path: ':logId',
              builder: (_, state) {
                final extra = state.extra;
                MaintenanceLog? log;
                if (extra is MaintenanceLog) log = extra;
                return MaintenanceLogFormPage(
                  vehicleId: state.pathParameters['id']!,
                  logId: state.pathParameters['logId'],
                  initialDescription: log?.description,
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/data',
      builder: (_, _) => const DataManagerPage(),
    ),
  ],
);

class _Shell extends StatelessWidget {
  final Widget child;

  const _Shell({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = location == '/dashboard'
        ? 0
        : location == '/more'
            ? 2
            : 1;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/dashboard');
            case 1:
              context.go('/');
            case 2:
              context.go('/more');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon: Icon(Icons.directions_car),
            label: 'Vehículos',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_outlined),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}

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
