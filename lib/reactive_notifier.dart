// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

/// A lightweight internal notifier to manage widget updates via [Key]-based references.
///
/// The [ReactiveNotifier] stores callback functions linked to widget keys.
/// These callbacks are executed to trigger `setState()` in the correct widget.
class ReactiveNotifier {
  /// Internal map storing update callbacks by widget [Key].
  final Map<Key, Function> _updates;

  /// Constructs a [ReactiveNotifier] with an empty update map.
  ReactiveNotifier() : _updates = {};

  /// Triggers an update for the widget associated with [key], if present.
  void updateOnly(Key key) {
    final update = _updates[key];
    if (update != null) {
      update();
    }
  }

  /// Triggers updates for all registered widgets.
  ///
  /// Widgets are updated in reverse order of insertion to prioritize
  /// more recently registered components.
  void updateAll() {
    final updates = _updates.values.toList(growable: false);
    for (var i = updates.length - 1; i >= 0; i--) {
      updates[i]();
    }
  }

  /// Registers a widget's [State] with a given [key].
  ///
  /// Internally stores a callback that will safely call `setState()` after
  /// the current frame, if the state is still mounted.
  void addUpdate(Key key, State state) {
    _updates[key] = (() {
      if (state.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          state.setState(() {});
        });
      }
    });
  }

  /// Unregisters the update function associated with [key].
  void removeUpdate(Key key) {
    _updates.remove(key);
  }
}
