/// Segmented control for picking one value of a setting.
library;

import 'package:flutter/material.dart';

/// One choice shown by [SegmentedSetting].
class SegmentOption<T> {
  /// Describes a choice with its [value], [label] and optional [icon].
  const SegmentOption({required this.value, required this.label, this.icon});

  /// Value reported when this option is selected.
  final T value;

  /// Visible text.
  final String label;

  /// Optional leading icon; hidden on narrow screens.
  final IconData? icon;
}

/// Full-width single-choice segmented button.
///
/// Labels stay on one line: icons are dropped below [iconsMinWidth] and
/// labels fade out instead of wrapping on very narrow screens.
class SegmentedSetting<T> extends StatelessWidget {
  /// Creates a control showing [options] with [selected] highlighted.
  const SegmentedSetting({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.iconsMinWidth = 400,
  });

  /// Choices in display order.
  final List<SegmentOption<T>> options;

  /// Currently selected value.
  final T selected;

  /// Called with the newly selected value.
  final ValueChanged<T> onChanged;

  /// Minimum control width at which icons are shown.
  final double iconsMinWidth;

  /// Compact segment padding so localized labels fit on narrow phones.
  static const ButtonStyle _style = ButtonStyle(
    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showIcons = constraints.maxWidth >= iconsMinWidth;

        return SizedBox(
          width: double.infinity,
          child: SegmentedButton<T>(
            style: _style,
            showSelectedIcon: false,
            segments: [
              for (final option in options)
                ButtonSegment<T>(
                  value: option.value,
                  label: Text(
                    option.label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                  icon: showIcons && option.icon != null
                      ? Icon(option.icon)
                      : null,
                ),
            ],
            selected: {selected},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        );
      },
    );
  }
}

/// A setting control with a caption above it.
class LabeledSetting extends StatelessWidget {
  /// Shows [label] above [child].
  const LabeledSetting({super.key, required this.label, required this.child});

  /// Caption text.
  final String label;

  /// The control itself.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
