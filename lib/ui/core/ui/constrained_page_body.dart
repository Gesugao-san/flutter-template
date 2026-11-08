/// Scrollable, centered, width-limited page body.
library;

import 'package:flutter/material.dart';

/// Aligns [child] (centered by default) and limits its width so content stays readable on wide
/// desktop and web windows, while scrolling on small phone screens.
class ConstrainedPageBody extends StatelessWidget {
  /// Wraps [child] in the standard page layout.
  const ConstrainedPageBody({
    super.key,
    required this.child,
    this.maxWidth = 560,
    this.alignment = Alignment.center,
  });

  /// Page content.
  final Widget child;

  /// Maximum content width in logical pixels.
  final double maxWidth;

  /// Where the content sits when it is smaller than the screen: centered
  /// for simple pages, [Alignment.topCenter] for forms and lists.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
