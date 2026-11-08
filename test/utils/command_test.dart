/// Unit tests for the command pattern helpers.
library;

import 'dart:async';

import 'package:flutter_template/utils/command.dart';
import 'package:flutter_template/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Command0', () {
    test('reports success', () async {
      final command = Command0<int>(() async => const Result.ok(42));

      await command.execute();

      expect(command.completed, isTrue);
      expect(command.error, isFalse);
      expect((command.result! as Ok<int>).value, 42);
    });

    test('reports failure and can clear it', () async {
      final command = Command0<void>(
        () async => Result.failure(Exception('boom')),
      );

      await command.execute();
      expect(command.error, isTrue);

      command.clearResult();
      expect(command.result, isNull);
    });

    test('ignores execution while already running', () async {
      final gate = Completer<Result<void>>();
      var calls = 0;
      final command = Command0<void>(() {
        calls++;
        return gate.future;
      });

      final first = command.execute();
      expect(command.running, isTrue);
      await command.execute();
      gate.complete(const Result.ok(null));
      await first;

      expect(calls, 1);
      expect(command.running, isFalse);
    });
  });

  test('Command1 passes its argument to the action', () async {
    final command = Command1<String, int>(
      (value) async => Result.ok('got $value'),
    );

    await command.execute(7);

    expect((command.result! as Ok<String>).value, 'got 7');
  });
}
