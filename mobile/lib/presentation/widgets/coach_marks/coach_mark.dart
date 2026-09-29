import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CoachMarkAnchor extends StatefulWidget {
  final String id;
  final Widget child;

  const CoachMarkAnchor({super.key, required this.id, required this.child});

  @override
  State<CoachMarkAnchor> createState() => CoachMarkAnchorState();
}

class CoachMarkAnchorState extends State<CoachMarkAnchor> {
  final GlobalKey _innerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    CoachMarkRegistry.register(widget.id, _innerKey);
  }

  @override
  void dispose() {
    CoachMarkRegistry.unregister(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _innerKey, child: widget.child);
  }
}

class CoachMarkRegistry {
  static final Map<String, GlobalKey> _keys = {};

  static void register(String id, GlobalKey key) => _keys[id] = key;

  static void unregister(String id) => _keys.remove(id);

  static Rect? rectOf(String id) {
    final key = _keys[id];
    final context = key?.currentContext;
    if (context == null) return null;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

class CoachMarkStep {
  final String anchorId;
  final IconData icon;
  final String title;
  final String description;

  const CoachMarkStep({
    required this.anchorId,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class CoachMarksController {
  final List<CoachMarkStep> steps;
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);
  OverlayEntry? _entry;
  bool _visible = false;
  int _index = 0;

  CoachMarksController(this.steps);

  ValueListenable<int> get indexListenable => _indexNotifier;

  bool get isVisible => _visible;

  int get index => _index;

  CoachMarkStep get current => steps[_index];

  void show(BuildContext context) {
    if (_visible || steps.isEmpty) return;
    _visible = true;
    _index = 0;
    _indexNotifier.value = 0;
    _entry = OverlayEntry(
      builder: (_) => _CoachMarksOverlay(controller: this),
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void next() {
    if (_index < steps.length - 1) {
      _index++;
      _indexNotifier.value = _index;
    } else {
      dismiss();
    }
  }

  void dismiss() {
    if (!_visible) return;
    _visible = false;
    _entry?.remove();
    _entry = null;
  }
}

class _CoachMarksOverlay extends StatefulWidget {
  final CoachMarksController controller;

  const _CoachMarksOverlay({required this.controller});

  @override
  State<_CoachMarksOverlay> createState() => _CoachMarksOverlayState();
}

class _CoachMarksOverlayState extends State<_CoachMarksOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.indexListenable.addListener(_onIndexChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  void _onIndexChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.indexListenable.removeListener(_onIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.controller.current;
    final target = CoachMarkRegistry.rectOf(step.anchorId);
    final size = MediaQuery.sizeOf(context);
    final horizontalPadding = MediaQuery.paddingOf(context).horizontal;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.controller.next,
            child: CustomPaint(
              painter: _SpotlightPainter(target: target),
              size: size,
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Easing.emphasizedDecelerate,
          left: _bubbleLeft(target, size.width, horizontalPadding),
          top: _bubbleTop(target, size.height, horizontalPadding),
          width: _bubbleWidth(size.width, horizontalPadding),
          child: _CoachMarkCard(controller: widget.controller),
        ),
      ],
    );
  }

  double _bubbleWidth(double screenWidth, double padding) {
    return (screenWidth - padding * 2).clamp(0.0, 360.0);
  }

  double _bubbleLeft(
    Rect? target,
    double screenWidth,
    double horizontalPadding,
  ) {
    final width = _bubbleWidth(screenWidth, horizontalPadding);
    final left = horizontalPadding;
    final maxLeft = screenWidth - width - horizontalPadding;
    if (target == null) return left;
    final centered = target.center.dx - width / 2;
    return centered.clamp(left, maxLeft);
  }

  double _bubbleTop(Rect? target, double screenHeight, double horizontalPadding) {
    const bubbleHeight = 168.0;
    final topInset = MediaQuery.paddingOf(context).top + 12;
    final maxTop = (screenHeight - bubbleHeight - 24).clamp(
      topInset,
      screenHeight - 24,
    );
    if (target == null) return maxTop;
    if (target.top - topInset >= bubbleHeight + 16) {
      return target.top - bubbleHeight - 12;
    }
    return (target.bottom + 12).clamp(topInset, maxTop);
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? target;

  _SpotlightPainter({required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black.withValues(alpha: 0.62),
    );
    final rect = target;
    if (rect == null) return;
    final radius = Radius.circular(20);
    final hole = Path()..addRRect(RRect.fromRectAndRadius(rect, radius));
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(hole, Paint()..color = Colors.white);
    canvas.drawPath(
      hole,
      Paint()
        ..blendMode = BlendMode.clear
        ..style = PaintingStyle.fill,
    );
    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(2), radius),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.target != target;
}

class _CoachMarkCard extends StatelessWidget {
  final CoachMarksController controller;

  const _CoachMarkCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final step = controller.current;
    final isLast = controller.index == controller.steps.length - 1;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    step.icon,
                    size: 22,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              step.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(controller.steps.length, (i) {
                  final isActive = i == controller.index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    width: isActive ? 20 : 7,
                    height: 7,
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
                  onPressed: controller.next,
                  child: Text(isLast ? l.coachMarkDone : l.coachMarkNext),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}