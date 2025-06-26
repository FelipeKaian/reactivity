// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'reactive.dart';

/// Internal class used to store a widget's subscription to reactive updates.
///
/// Each [Notifier] holds a [UniqueKey] to identify the widget, and a
/// reference to the widget’s [setState] function.
class Notifier {
  final UniqueKey key;
  final void Function(VoidCallback) setState;

  Notifier(this.key, this.setState);
}

/// Manages subscriptions and triggers rebuilds for all reactive widgets.
///
/// This class is the core engine behind the `Reactivity` system.
/// It maps keys (used by `Reactive`, `ReactiveStatus`, `ValueState`, etc.)
/// to their corresponding [State.setState] callbacks and invokes them
/// when needed.
///
/// It provides four types of rebuild operations:
/// - [updateOnly] → one specific key
/// - [update] → all general reactive widgets
/// - [updateStatus] → all listeners of a given status type
/// - [updateState] → specific `InitedState`, `ValueState`, etc.
class ReactiveNotifier {
  /// Internal registry mapping keys to sets of [Notifier]s.
  final Map<Key, List<Notifier>> _updates;

  /// Creates a new reactive notifier.
  ///
  /// This is typically instantiated once in [Reactivity.notifier].
  ReactiveNotifier() : _updates = {};

  /// Rebuilds only widgets that are subscribed to a specific [key].
  ///
  /// This is used in [refreshOnly] and custom reactive keys.
  void updateOnly(Key key) {
    final notifiers = _updates[key];
    if (notifiers != null) {
      for (var i = notifiers.length - 1; i >= 0; i--) {
        rebuild(notifiers[i].setState);
      }
    }
  }

  /// Rebuilds all widgets that were subscribed to the general [Reactive] key.
  ///
  /// This is used when calling [refresh()] without a key.
  void update() {
    final notifiers = _updates[ValueKey(Reactive)];
    if (notifiers != null) {
      for (var i = notifiers.length - 1; i >= 0; i--) {
        rebuild(notifiers[i].setState);
      }
    }
  }

  /// Rebuilds all widgets listening to a specific runtime type status.
  ///
  /// Used by [refreshStatus], based on the type of the status object.
  void updateStatus(dynamic status) {
    final notifiers = _updates[ValueKey(status.runtimeType)];
    if (notifiers != null) {
      for (var i = notifiers.length - 1; i >= 0; i--) {
        rebuild(notifiers[i].setState);
      }
    }
  }

  /// Rebuilds widgets tied to a specific state key, typically from `InitedState`, `ValueState`, or `VoidState`.
  ///
  /// Used internally by [refreshWith] and [refreshUpdate].
  void updateState(UniqueKey uniqueKey) {
    final notifiers = _updates[uniqueKey];
    if (notifiers != null) {
      for (var i = notifiers.length - 1; i >= 0; i--) {
        rebuild(notifiers[i].setState);
      }
    }
  }

  /// Registers a widget’s subscription to reactive updates for a given [key].
  ///
  /// This is typically called in a widget’s `initState()`.
  void addUpdate(Key key, UniqueKey uniqueKey, State state) {
    final notifier = Notifier(
      uniqueKey,
      state.setState,
    );
    _updates.putIfAbsent(key, () => <Notifier>[]).add(notifier);
  }

  /// Removes a widget’s subscription for a specific [key] and [uniqueKey].
  ///
  /// This is typically called in `dispose()` to prevent memory leaks.
  void removeUpdate(Key key, UniqueKey uniqueKey) {
    _updates[key]?.removeWhere((notifier) => notifier.key == uniqueKey);
    if (_updates[key]?.isEmpty ?? false) {
      _updates.remove(key);
    }
  }

  /// Schedules a rebuild of a widget using [setState] in the next frame.
  ///
  /// This ensures rebuilds are deferred until the current frame ends,
  /// avoiding conflicts with the Flutter rendering pipeline.
  void rebuild(void Function(VoidCallback) setState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }
}
