import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/onboarding_helper.dart';
import 'package:mobile/l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _totalSlides = 8;

  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _totalSlides - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Easing.emphasizedDecelerate,
      );
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Easing.emphasizedDecelerate,
      );
    }
  }

  Future<void> _finish() async {
    await markOnboardingSeen();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _addFirstVehicle() async {
    await markOnboardingSeen();
    if (mounted) context.go('/vehicle/new');
  }

  Future<void> _explore() async {
    await markOnboardingSeen();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _currentPage == 0 ? 0 : 1,
                    child: IconButton(
                      tooltip: l.back,
                      onPressed: _currentPage == 0 ? null : _back,
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: Text(l.onboardingSkip),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _OnboardingSlide(
                    illustration: Image.asset(
                      'assets/branding/karter-icon-1024.png',
                      width: 132,
                      height: 132,
                    ),
                    title: l.onboardingWelcomeTitle,
                    description: l.onboardingWelcomeDesc,
                  ),
                  _OnboardingSlide(
                    icon: Icons.dashboard_outlined,
                    title: l.onboardingDashboardTitle,
                    description: l.onboardingDashboardDesc,
                    illustration: const _DashboardMock(),
                  ),
                  _OnboardingSlide(
                    icon: Icons.directions_car_filled,
                    title: l.onboardingVehicleTitle,
                    description: l.onboardingVehicleDesc,
                    illustration: const _VehicleMock(),
                  ),
                  _OnboardingSlide(
                    icon: Icons.local_gas_station,
                    title: l.onboardingTrackTitle,
                    description: l.onboardingTrackDesc,
                    illustration: const _FuelMock(),
                  ),
                  _OnboardingSlide(
                    icon: Icons.speed,
                    title: l.onboardingObdTitle,
                    description: l.onboardingObdDesc,
                    illustration: const _ObdMock(),
                  ),
                  _OnboardingSlide(
                    icon: Icons.notifications_outlined,
                    title: l.onboardingRemindersTitle,
                    description: l.onboardingRemindersDesc,
                    illustration: const _ReminderMock(),
                  ),
                  _OnboardingSlide(
                    icon: Icons.cloud_done_outlined,
                    title: l.onboardingBackupsTitle,
                    description: l.onboardingBackupsDesc,
                    illustration: const _BackupMock(),
                  ),
                  _WelcomeFinalSlide(
                    onAddVehicle: _addFirstVehicle,
                    onExplore: _explore,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  ...List.generate(_totalSlides, (i) {
                    final isActive = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      width: isActive ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                  const Spacer(),
                  if (_currentPage < _totalSlides - 1)
                    FilledButton(
                      onPressed: _next,
                      child: Text(l.onboardingNext),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final IconData? icon;
  final Widget? illustration;
  final String title;
  final String description;

  const _OnboardingSlide({
    this.icon,
    this.illustration,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (illustration != null)
            illustration!
          else
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          const SizedBox(height: 40),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WelcomeFinalSlide extends StatelessWidget {
  final VoidCallback onAddVehicle;
  final VoidCallback onExplore;

  const _WelcomeFinalSlide({
    required this.onAddVehicle,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.garage,
              size: 56,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            l.onboardingDone,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: onAddVehicle,
            icon: const Icon(Icons.add),
            label: Text(l.onboardingAddFirstVehicle),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onExplore,
            child: Text(l.onboardingExploreApp),
          ),
        ],
      ),
    );
  }
}

class _MockFrame extends StatelessWidget {
  final Widget child;

  const _MockFrame({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DashboardMock extends StatelessWidget {
  const _DashboardMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final value = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return _MockFrame(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Icon(Icons.build, size: 20, color: theme.colorScheme.primary),
                const SizedBox(height: 6),
                Text('2', style: value),
                Text('Service', style: label),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(Icons.local_gas_station,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(height: 6),
                Text('6.2', style: value),
                Text('L/100km', style: label),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Icon(Icons.check_circle,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(height: 6),
                Text('12', style: value),
                Text('Logs', style: label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleMock extends StatelessWidget {
  const _VehicleMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _MockFrame(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car,
              size: 24,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Golf GTI',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '48,200 km',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _FuelMock extends StatelessWidget {
  const _FuelMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _MockFrame(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_gas_station,
                  size: 22,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fuel up', style: theme.textTheme.titleSmall),
                    Text(
                      '42 L · 21.30 €',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '5.9 L/100km · 800 km range',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ObdMock extends StatelessWidget {
  const _ObdMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _MockFrame(
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: CustomPaint(
              painter: _GaugePainter(
                progress: 0.68,
                color: theme.colorScheme.primary,
                trackColor: theme.colorScheme.surfaceContainerHigh,
              ),
              child: Center(
                child: Text(
                  '2,450',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('RPM', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Text(
                  'No DTCs',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _GaugePainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = -0.75 * 3.1415926535897932;
    const sweep = 1.5 * 3.1415926535897932;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 6;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    stroke.color = trackColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep,
      false,
      stroke,
    );
    stroke.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep * progress,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}

class _ReminderMock extends StatelessWidget {
  const _ReminderMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _MockFrame(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 22,
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Oil change due', style: theme.textTheme.titleSmall),
                Text(
                  'in 800 km',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupMock extends StatelessWidget {
  const _BackupMock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _MockFrame(
      child: Column(
        children: [
          Icon(
            Icons.cloud_done,
            size: 40,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Synced · Drive',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Encrypted & private',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}