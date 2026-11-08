/// Shows a snack bar when any of the given commands fails.
library;

import 'package:flutter/material.dart';

import '../../../utils/command.dart';

/// Listens to [commands] and shows [message] in a snack bar whenever one of
/// them finishes with an error, then clears that error.
///
/// Keeps error presentation out of view models and out of every screen.
class CommandErrorListener extends StatefulWidget {
  /// Watches [commands] while [child] is shown.
  const CommandErrorListener({
    super.key,
    required this.commands,
    required this.message,
    required this.child,
  });

  /// Commands to watch.
  final List<Command<Object?>> commands;

  /// Text shown when a command fails.
  final String message;

  /// Content below the listener.
  final Widget child;

  @override
  State<CommandErrorListener> createState() => _CommandErrorListenerState();
}

class _CommandErrorListenerState extends State<CommandErrorListener> {
  @override
  void initState() {
    super.initState();
    for (final command in widget.commands) {
      command.addListener(_onCommandChanged);
    }
  }

  @override
  void dispose() {
    for (final command in widget.commands) {
      command.removeListener(_onCommandChanged);
    }
    super.dispose();
  }

  /// Reports the first failed command and resets it.
  void _onCommandChanged() {
    final failed = widget.commands
        .where((command) => command.error)
        .firstOrNull;
    if (failed == null) return;

    failed.clearResult();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(widget.message)));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
