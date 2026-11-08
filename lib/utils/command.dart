/// Command pattern for user actions, as recommended by the Flutter
/// architecture guide.
library;

import 'package:flutter/foundation.dart';

import 'result.dart';

/// Action without arguments executed by [Command0].
typedef CommandAction0<T> = Future<Result<T>> Function();

/// Action with one argument executed by [Command1].
typedef CommandAction1<T, A> = Future<Result<T>> Function(A argument);

/// Wraps an asynchronous action and exposes its state to the UI.
///
/// Views listen to a command to show progress ([running]) and react to the
/// outcome ([completed], [error]) without holding any logic themselves. A
/// command ignores new executions while one is still running.
abstract class Command<T> extends ChangeNotifier {
  bool _running = false;
  Result<T>? _result;

  /// Whether the action is currently executing.
  bool get running => _running;

  /// Whether the last execution failed.
  bool get error => _result is Failure<T>;

  /// Whether the last execution succeeded.
  bool get completed => _result is Ok<T>;

  /// Result of the last execution, or `null` if there is none yet.
  Result<T>? get result => _result;

  /// Forgets the last result, e.g. after the view has shown an error.
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Runs [action] unless another execution is in progress.
  Future<void> _execute(CommandAction0<T> action) async {
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// [Command] whose action takes no arguments.
class Command0<T> extends Command<T> {
  /// Creates a command for [_action].
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() => _execute(_action);
}

/// [Command] whose action takes one argument of type [A].
class Command1<T, A> extends Command<T> {
  /// Creates a command for [_action].
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with [argument].
  Future<void> execute(A argument) => _execute(() => _action(argument));
}
