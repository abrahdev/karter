import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/presentation/pages/home_page.dart';
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
