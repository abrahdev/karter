import 'package:flutter/material.dart';
import 'package:mobile/core/onboarding_helper.dart';
import 'package:mobile/l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 3) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Easing.emphasizedDecelerate,
      );
    } else {
      _finish();
    }
  }

  void _finish() async {
    await markOnboardingSeen();
    if (mounted) Navigator.of(context).pop();
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
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(l.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _OnboardingSlide(
                    iconWidget: Image.asset(
                      'assets/branding/karter-icon-1024.png',
                      width: 120,
                      height: 120,
                    ),
                    title: l.onboardingWelcomeTitle,
                    description: l.onboardingWelcomeDesc,
                  ),
                  const _OnboardingSlide(
                    icon: Icons.directions_car_filled,
                    titleKey: 'vehicle',
                  ),
                  const _OnboardingSlide(
                    icon: Icons.local_gas_station,
                    titleKey: 'track',
                  ),
                  const _OnboardingSlide(
                    icon: Icons.notifications_outlined,
                    titleKey: 'reminders',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                children: [
                  ...List.generate(4, (i) {
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
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _currentPage == 3
                          ? l.onboardingDone
                          : l.onboardingNext,
                    ),
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
  final Widget? iconWidget;
  final String? titleKey;
  final String? title;
  final String? description;

  const _OnboardingSlide({
    this.icon,
    this.iconWidget,
    this.titleKey,
    this.title,
    this.description,
  });

  String _getTitle(AppLocalizations l) {
    if (title != null) return title!;
    return switch (titleKey) {
      'vehicle' => l.onboardingVehicleTitle,
      'track' => l.onboardingTrackTitle,
      'reminders' => l.onboardingRemindersTitle,
      _ => '',
    };
  }

  String _getDescription(AppLocalizations l) {
    if (description != null) return description!;
    return switch (titleKey) {
      'vehicle' => l.onboardingVehicleDesc,
      'track' => l.onboardingTrackDesc,
      'reminders' => l.onboardingRemindersDesc,
      _ => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconWidget != null)
            iconWidget!
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
            _getTitle(l),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _getDescription(l),
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
