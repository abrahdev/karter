import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/data/services/native_window_service.dart';
import 'package:window_manager/window_manager.dart';

class LinuxTitleBar extends StatefulWidget {
  final Widget child;

  const LinuxTitleBar({super.key, required this.child});

  @override
  State<LinuxTitleBar> createState() => _LinuxTitleBarState();
}

class _LinuxTitleBarState extends State<LinuxTitleBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _checkMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _checkMaximized() async {
    final isMaximized = await windowManager.isMaximized();
    if (mounted) {
      setState(() => _isMaximized = isMaximized);
    }
  }

  @override
  void onWindowMaximize() {
    setState(() => _isMaximized = true);
  }

  @override
  void onWindowUnmaximize() {
    setState(() => _isMaximized = false);
  }

  Future<void> _toggleMaximize() async {
    if (_isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 40,
          color: theme.colorScheme.surface,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onPanStart: (_) => windowManager.startDragging(),
                  onDoubleTap: () => _toggleMaximize(),
                  onSecondaryTap: () => NativeWindowService.showWindowMenu(),
                  child: Container(
                    color: theme.colorScheme.surface,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _WindowButton(
                      icon: Icons.remove,
                      onTap: () => windowManager.minimize(),
                      isDark: isDark,
                    ),
                    _WindowButton(
                      icon: _isMaximized ? Icons.filter_none : Icons.crop_square,
                      onTap: () => _toggleMaximize(),
                      isDark: isDark,
                      iconSize: _isMaximized ? 14 : 16,
                    ),
                    _WindowButton(
                      icon: Icons.close,
                      onTap: () => windowManager.close(),
                      isDark: isDark,
                      isClose: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  final bool isClose;
  final double iconSize;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
    this.isClose = false,
    this.iconSize = 16,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color hoverColor;
    if (widget.isClose && _isHovered) {
      hoverColor = Colors.red;
    } else {
      hoverColor = widget.isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.08);
    }

    Color iconColor;
    if (widget.isClose && _isHovered) {
      iconColor = Colors.white;
    } else {
      iconColor = theme.colorScheme.onSurface;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered ? hoverColor : Colors.transparent,
            shape: widget.isClose ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.isClose ? null : BorderRadius.zero,
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

bool get isDesktop =>
    Platform.isLinux || Platform.isWindows || Platform.isMacOS;
