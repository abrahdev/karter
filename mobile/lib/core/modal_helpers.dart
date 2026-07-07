import 'package:flutter/material.dart';

class _KarterDialogRoute<T> extends RawDialogRoute<T> {
  _KarterDialogRoute({
    required super.pageBuilder,
    required this.openDuration,
    required this.closeDuration,
    super.barrierDismissible,
    super.barrierLabel,
    super.barrierColor,
    super.transitionBuilder,
    super.settings,
  });

  final Duration openDuration;
  final Duration closeDuration;

  @override
  Duration get transitionDuration => openDuration;

  @override
  Duration get reverseTransitionDuration => closeDuration;
}

Future<T?> karterShowDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final theme = Theme.of(context);
  final barrierLabel = MaterialLocalizations.of(context).modalBarrierDismissLabel;

  return Navigator.of(context, rootNavigator: true).push<T>(
    _KarterDialogRoute<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
          child: Builder(builder: builder),
        );
      },
      openDuration: Durations.medium4,
      closeDuration: Durations.short4,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnim = CurvedAnimation(
          parent: animation,
          curve: Easing.emphasizedDecelerate,
          reverseCurve: Easing.emphasizedAccelerate,
        );
        final scaleAnim = CurvedAnimation(
          parent: animation,
          curve: Easing.emphasizedDecelerate,
          reverseCurve: Easing.emphasizedAccelerate,
        );
        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            child: child,
          ),
        );
      },
    ),
  );
}

Future<T?> karterShowModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
}) {
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  final barrierLabel = MaterialLocalizations.of(context).modalBarrierDismissLabel;
  final maxHeight = mediaQuery.size.height * (isScrollControlled ? 0.9 : 0.5);
  final bottomInset = mediaQuery.viewInsets.bottom;

  return Navigator.of(context, rootNavigator: true).push<T>(
    _KarterDialogRoute<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Material(
              color: theme.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: SafeArea(
                    top: false,
                    child: builder(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      openDuration: Durations.medium4,
      closeDuration: Durations.short4,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Easing.emphasizedDecelerate,
            reverseCurve: Easing.emphasizedAccelerate,
          )),
          child: child,
        );
      },
    ),
  );
}
