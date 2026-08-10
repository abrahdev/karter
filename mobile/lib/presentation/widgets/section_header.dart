import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final double topPadding;
  final double bottomPadding;
  final double leftPadding;

  const SectionHeader({
    super.key,
    required this.title,
    this.topPadding = 20,
    this.bottomPadding = 8,
    this.leftPadding = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        bottom: bottomPadding,
        left: leftPadding,
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
