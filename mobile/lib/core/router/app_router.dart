import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/pages/dashboard_page.dart';
import 'package:mobile/presentation/pages/data_manager_page.dart';
import 'package:mobile/presentation/pages/document_list_page.dart';
import 'package:mobile/presentation/pages/feedback_page.dart';
import 'package:mobile/presentation/pages/fuel_log_list_page.dart';
import 'package:mobile/presentation/pages/home_page.dart';
import 'package:mobile/presentation/pages/maintenance_log_list_page.dart';
import 'package:mobile/presentation/pages/maintenance_settings_page.dart';
import 'package:mobile/presentation/pages/more_page.dart';
import 'package:mobile/presentation/pages/notification_list_page.dart';
import 'package:mobile/presentation/pages/obd_page.dart';
import 'package:mobile/presentation/pages/onboarding_page.dart';
import 'package:mobile/presentation/pages/parts_list_page.dart';
import 'package:mobile/presentation/pages/privacy_policy_page.dart';
import 'package:mobile/presentation/pages/tips_page.dart';
import 'package:mobile/presentation/pages/vehicle_detail_page.dart';
import 'package:mobile/presentation/pages/vehicle_form_page.dart';
import 'package:mobile/presentation/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (_, _, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (_, _) => const DashboardPage(),
        ),
        GoRoute(path: '/', builder: (_, _) => const HomePage()),
        GoRoute(
          path: '/obd',
          builder: (_, _) => const ObdPage(),
        ),
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
        ),
        GoRoute(
          path: 'documents',
          builder: (_, state) => DocumentListPage(
            vehicleId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'parts',
          builder: (_, state) => PartsListPage(
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
              path: 'settings',
              builder: (_, state) => MaintenanceSettingsPage(
                vehicleId: state.pathParameters['id']!,
              ),
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
      builder: (_, _) => const NotificationListPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, _) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/feedback',
      builder: (_, _) => const FeedbackPage(),
    ),
    GoRoute(
      path: '/tips',
      builder: (_, _) => const TipsPage(),
    ),
    GoRoute(
      path: '/privacy',
      builder: (_, _) => const PrivacyPolicyPage(),
    ),
  ],
);
