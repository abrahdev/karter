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
  return Navigator.of(context, rootNavigator: true).push<T>(
    _KarterDialogRoute<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          child: Builder(builder: builder),
        );
      },
      openDuration: const Duration(milliseconds: 500),
      closeDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: curved,
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
  return Navigator.of(context, rootNavigator: true).push<T>(
    _KarterDialogRoute<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    (isScrollControlled ? 0.9 : 0.5),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SafeArea(
                top: false,
                child: builder(context),
              ),
            ),
          ),
        );
      },
      openDuration: const Duration(milliseconds: 500),
      closeDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        );
      },
    ),
  );
}
