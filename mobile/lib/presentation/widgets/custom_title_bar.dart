import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class CustomTitleBar extends StatefulWidget {
  final String? title;

  const CustomTitleBar({super.key, this.title});

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _updateMaximizedState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _updateMaximizedState() async {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 38,
      color: isDark
          ? theme.colorScheme.surface
          : theme.colorScheme.surfaceContainerLowest,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (_) => windowManager.startDragging(),
              onDoubleTap: () => _toggleMaximize(),
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title ?? 'Karter',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
          _WindowButtons(
            isMaximized: _isMaximized,
            isDark: isDark,
            onMinimize: () => windowManager.minimize(),
            onMaximize: () => _toggleMaximize(),
            onClose: () => windowManager.close(),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleMaximize() async {
    if (_isMaximized) {
      await windowManager.unmaximize();
    } else {
      await windowManager.maximize();
    }
  }
}

class _WindowButtons extends StatefulWidget {
  final bool isMaximized;
  final bool isDark;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onClose;

  const _WindowButtons({
    required this.isMaximized,
    required this.isDark,
    required this.onMinimize,
    required this.onMaximize,
    required this.onClose,
  });

  @override
  State<_WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<_WindowButtons> {
  bool _isMinimizeHovered = false;
  bool _isMaximizeHovered = false;
  bool _isCloseHovered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WindowButton(
          icon: Icons.remove,
          isHovered: _isMinimizeHovered,
          hoverColor: widget.isDark ? Colors.white12 : Colors.black12,
          onEnter: () => setState(() => _isMinimizeHovered = true),
          onExit: () => setState(() => _isMinimizeHovered = false),
          onTap: widget.onMinimize,
          tooltip: 'Minimize',
        ),
        _WindowButton(
          icon: widget.isMaximized ? Icons.filter_none : Icons.crop_square,
          isHovered: _isMaximizeHovered,
          hoverColor: widget.isDark ? Colors.white12 : Colors.black12,
          onEnter: () => setState(() => _isMaximizeHovered = true),
          onExit: () => setState(() => _isMaximizeHovered = false),
          onTap: widget.onMaximize,
          tooltip: widget.isMaximized ? 'Restore' : 'Maximize',
          iconSize: widget.isMaximized ? 14 : 16,
        ),
        _WindowButton(
          icon: Icons.close,
          isHovered: _isCloseHovered,
          hoverColor: Colors.red,
          onEnter: () => setState(() => _isCloseHovered = true),
          onExit: () => setState(() => _isCloseHovered = false),
          onTap: widget.onClose,
          tooltip: 'Close',
          isClose: true,
        ),
      ],
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final bool isHovered;
  final Color hoverColor;
  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;
  final String tooltip;
  final bool isClose;
  final double? iconSize;

  const _WindowButton({
    required this.icon,
    required this.isHovered,
    required this.hoverColor,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
    required this.tooltip,
    this.isClose = false,
    this.iconSize,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = widget.isClose && widget.isHovered
        ? Colors.white
        : theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => widget.onEnter(),
      onExit: (_) => widget.onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 46,
          height: 38,
          decoration: BoxDecoration(
            color: widget.isHovered ? widget.hoverColor : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            size: widget.iconSize ?? 16,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

bool get isDesktop =>
    Platform.isLinux || Platform.isWindows || Platform.isMacOS;
