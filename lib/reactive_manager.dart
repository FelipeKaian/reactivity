/// Main library of the `reactive` package.
///
/// Provides a lightweight reactive state mechanism using `Key`-based identifiers
/// and global enum-based status tracking.

library reactivity;

import 'dart:collection';
import 'package:flutter/widgets.dart';

import 'reactive_notifier.dart';

/// Alias for reactive keys used to identify and refresh specific widgets.
typedef ReactiveKey = Key;

/// Core class that manages reactive updates and status enums.
///
/// The [Reactivity] class holds global status values (usually enums) and
/// provides methods to refresh individual widgets or all widgets via keys.
class Reactivity {
  /// Internal map that holds the latest value for each status enum,
  /// using the enum type name as a key.
  static final SplayTreeMap<String, dynamic> _status = SplayTreeMap();

  /// Central notifier that tracks and updates widgets by their [ReactiveKey].
  static ReactiveNotifier notifier = ReactiveNotifier();

  /// Refreshes a specific widget associated with [key], or all widgets if [key] is null.
  static void refresh(ReactiveKey? key) {
    if (key != null) {
      notifier.updateOnly(key);
    } else {
      notifier.updateAll();
    }
  }

  /// Returns the current status associated with a given enum [Type].
  ///
  /// Example:
  /// ```dart
  /// final current = Reactivity.statusOf(MyEnum);
  /// ```
  static dynamic statusOf(Type statusEnum) {
    return _status[statusEnum.toString()];
  }

  /// Sets the value of a status enum. It can later be retrieved with [statusOf].
  static void setStatus(dynamic enumValue) {
    _status[enumValue.runtimeType.toString()] = enumValue;
  }

  /// Sets the status and triggers a refresh for widgets associated with that enum type.
  static void refreshStatus(dynamic status) {
    _status[status.runtimeType.toString()] = status;
    refresh(ValueKey(status.runtimeType));
  }
}

/// Global helper to refresh the widget associated with [key], or all if [key] is null.
void refresh([ReactiveKey? key]) {
  Reactivity.refresh(key);
}

/// Global helper to refresh all widgets.
void refreshAll() {
  Reactivity.refresh(null);
}

/// Global helper to refresh only the widget associated with [key].
void refreshOnly(ReactiveKey key) {
  Reactivity.refresh(key);
}

/// Global helper to set the current status of an enum.
void setStatus(dynamic status) {
  Reactivity.setStatus(status);
}

/// Global helper to set and refresh status-based widgets.
void refreshStatus(dynamic status) {
  Reactivity.refreshStatus(status);
}
