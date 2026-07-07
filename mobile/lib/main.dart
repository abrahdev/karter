import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/services/background_service.dart';
import 'package:mobile/data/services/notification_service.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/presentation/providers/locale_provider.dart';
import 'package:mobile/presentation/providers/vehicle_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_theme/system_theme.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mobile/presentation/pages/dashboard_page.dart';
import 'package:mobile/presentation/pages/data_manager_page.dart';
import 'package:mobile/presentation/pages/document_list_page.dart';
import 'package:mobile/presentation/pages/fuel_log_form_page.dart';
import 'package:mobile/presentation/pages/fuel_log_list_page.dart';
import 'package:mobile/presentation/pages/home_page.dart';
import 'package:mobile/domain/entities/maintenance_log.dart';
import 'package:mobile/presentation/pages/maintenance_log_form_page.dart';
import 'package:mobile/presentation/pages/maintenance_log_list_page.dart';
import 'package:mobile/presentation/pages/maintenance_settings_page.dart';
import 'package:mobile/presentation/pages/more_page.dart';
import 'package:mobile/presentation/pages/notification_settings_page.dart';
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
              path: 'documents',
              builder: (_, state) => DocumentListPage(
                vehicleId: state.pathParameters['id']!,
              ),
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
    GoRoute(
      path: '/notifications',
      builder: (_, _) => const _NotificationListPage(),
    ),
    GoRoute(
      path: '/notifications/:vehicleId',
      builder: (_, state) => NotificationSettingsPage(
        vehicleId: state.pathParameters['vehicleId']!,
      ),
    ),
  ],
);

class _Shell extends StatefulWidget {
  final Widget child;

  const _Shell({required this.child});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  bool _extended = true;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = location == '/dashboard'
        ? 0
        : location == '/more'
            ? 2
            : 1;

    void onDestinationSelected(int i) {
      switch (i) {
        case 0:
          context.go('/dashboard');
        case 1:
          context.go('/');
        case 2:
          context.go('/more');
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final l = AppLocalizations.of(context)!;

        if (constraints.maxWidth >= 768) {
          final canExtend = constraints.maxWidth >= 1024;
          if (!canExtend && _extended) _extended = false;

          final extended = canExtend && _extended;

          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: onDestinationSelected,
                  labelType: extended ? null : NavigationRailLabelType.all,
                  extended: extended,
                  trailingAtBottom: true,
                  trailing: canExtend
                      ? IconButton(
                          icon: Icon(extended ? Icons.chevron_left : Icons.chevron_right),
                          onPressed: () => setState(() => _extended = !_extended),
                        )
                      : null,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard),
                      label: Text(l.navDashboard),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.directions_car_outlined),
                      selectedIcon: Icon(Icons.directions_car),
                      label: Text(l.navVehicles),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.more_horiz_outlined),
                      selectedIcon: Icon(Icons.more_horiz),
                      label: Text(l.navMore),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: widget.child),
              ],
            ),
          );
        }

        return Scaffold(
          body: widget.child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: l.navDashboard,
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_car_outlined),
                selectedIcon: Icon(Icons.directions_car),
                label: l.navVehicles,
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz_outlined),
                selectedIcon: Icon(Icons.more_horiz),
                label: l.navMore,
              ),
            ],
          ),
        );
      },
    );
  }
}

class KarterApp extends ConsumerWidget {
  final Color initialAccent;

  const KarterApp({super.key, required this.initialAccent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return StreamBuilder<SystemAccentColor>(
      stream: SystemTheme.onChange,
      builder: (context, snapshot) {
        final color = snapshot.data?.accent ?? initialAccent;
        final lightScheme = ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.light,
        );
        final darkScheme = ColorScheme.fromSeed(
          seedColor: color,
          brightness: Brightness.dark,
        );

        return MaterialApp.router(
          title: 'Karter',
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.from(lightScheme, Brightness.light),
          darkTheme: AppTheme.from(darkScheme, Brightness.dark),
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class _NotificationListPage extends ConsumerWidget {
  const _NotificationListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehicleListProvider);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.notificationSettingsTitle)),
      body: vehiclesAsync.when(
        data: (vehicles) {
          if (vehicles.isEmpty) {
            return Center(child: Text(l.notificationNoVehicles));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vehicles.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (_, i) {
              final v = vehicles[i];
              final label = v.alias ?? '${v.brand} ${v.model}';
              final freq = v.odometerReminderFreqDays;
              final maintOn = v.maintenanceReminderEnabled;
              return ListTile(
                title: Text(label),
                subtitle: Text(
                  l.notificationVehicleSubtitle(
                    freq != null ? l.notificationFreqValue(freq) : l.notificationFreqOff,
                    maintOn ? l.notificationMaintOn : l.notificationMaintOff,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () => context.push('/notifications/${v.id}'),
                  child: Text(l.notificationConfigure),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.homeError(e))),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemTheme.fallbackColor = AppTheme.fallbackSeed;
  await SystemTheme.accentColor.load();
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('locale') ?? 'es';

  if (Platform.isAndroid || Platform.isIOS) {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    await Workmanager().registerPeriodicTask(
      'karter-reminder-check',
      'odometerMaintenanceCheck',
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
      ),
    );
  }

  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith(() => createLocaleNotifier(savedLocale)),
        notificationServiceProvider.overrideWith((ref) {
          notificationService.init();
          return notificationService;
        }),
      ],
      child: KarterApp(initialAccent: SystemTheme.accentColor.accent),
    ),
  );
}
