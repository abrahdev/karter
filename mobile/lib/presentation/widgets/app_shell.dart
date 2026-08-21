import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _extended = true;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = switch (location) {
      '/dashboard' => 0,
      '/obd' => 2,
      '/more' => 3,
      _ => 1,
    };

    void onDestinationSelected(int i) {
      switch (i) {
        case 0:
          context.go('/dashboard');
        case 1:
          context.go('/');
        case 2:
          context.go('/obd');
        case 3:
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
                      icon: Icon(Icons.speed_outlined),
                      selectedIcon: Icon(Icons.speed),
                      label: Text(l.navObd),
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
                icon: Icon(Icons.speed_outlined),
                selectedIcon: Icon(Icons.speed),
                label: l.navObd,
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
