library reactive;

import 'package:flutter/widgets.dart';
import 'reactive_notifier.dart';

/// A shortcut type alias for uniquely identifying reactive widgets.
///
/// This is typically a [ValueKey], [UniqueKey], or any other [Key] used
/// to control rebuild behavior via the `ReactiveNotifier`.
typedef ReactiveKey = Key;

/// Defines the types of reactivity handled internally by the system.
enum ReactivityTypeEnum {
  /// Represents widget rebuilds triggered manually via `refresh()` or `refreshOnly()`.
  reactive,

  /// Represents widget rebuilds based on a global status value, accessed via `getStatus<T>()`.
  reactiveStatus,

  /// Represents widget rebuilds based on an internally managed state,
  /// such as [ValueState], [InitedState], or [VoidState].
  reactiveStates,
}

/// A singleton-like static class that serves as the central controller
/// for all reactive operations in the system.
///
/// It tracks internal state objects, manages reactive rebuilds, and
/// dispatches updates through a shared [ReactiveNotifier].
class Reactivity {
  /// Shared notifier responsible for dispatching widget rebuilds.
  static ReactiveNotifier notifier = ReactiveNotifier();

  /// Internal storage of globally tracked status values, indexed by type.
  ///
  /// These values can be retrieved using [getStatus<T>()] and refreshed using [refreshStatus()].
  static final Map<Key, dynamic> _status = {};

  /// Internal map of active states bound to their corresponding keys.
  ///
  /// This is used by [ValueState], [InitedState], and [VoidState] to track and rebuild widgets.
  static final Map<Key, BuildState> _states = {};

  /// Tracks the most recently updated state key.
  ///
  /// Used internally to determine which state is "active" for purposes such as inspection.
  static Key lastStateKey = UniqueKey();

  /// Triggers a rebuild for either a specific widget (if [key] is provided)
  /// or for all reactive widgets if [key] is null.
  ///
  /// Typically used in combination with a `Reactive` widget or any reactive consumer.
  static void refresh(ReactiveKey? key) {
    if (key != null) {
      notifier.updateOnly(key);
    } else {
      notifier.update();
    }
  }

  /// Updates the stored value for a given [status] and notifies
  /// all widgets that are subscribed to that status type.
  ///
  /// Example:
  /// ```dart
  /// refreshStatus(MyEnum.loading);
  /// ```
  static void refreshStatus(dynamic status) {
    Reactivity._status[ValueKey(status.runtimeType)] = status;
    notifier.updateStatus(status);
  }

  /// Returns the most recently registered [BuildState], typically
  /// corresponding to the last state that was updated.
  static dynamic getLastBuildState() {
    return _states[lastStateKey];
  }
}

/// Triggers a full rebuild or a specific reactive key.
///
/// Equivalent to calling [Reactivity.refresh].
void refresh([ReactiveKey? key]) {
  Reactivity.refresh(key);
}

/// Triggers a rebuild only for the widget associated with [key].
void refreshOnly(ReactiveKey key) {
  Reactivity.refresh(key);
}

/// Updates a global status value and triggers rebuilds for any listeners
/// that depend on the status of that type.
///
/// This allows widgets to react to application-wide changes in state
/// without explicitly tracking value instances.
void refreshStatus(dynamic status) {
  Reactivity.refreshStatus(status);
}

/// Retrieves a globally tracked status value by type.
///
/// This is useful for accessing values set via [refreshStatus] and
/// reacting to enum-based application state.
///
/// Example:
/// ```dart
/// final currentStatus = getStatus<MyStatus>();
/// ```
T getStatus<T>() {
  return Reactivity._status[ValueKey(T)] as T;
}

/// Encapsulates a builder function tied to a unique key, allowing widgets
/// to rebuild reactively based on key-based updates.
class StateBuilder {
  final UniqueKey uniqueKey;
  final Widget Function(dynamic) build;

  /// Creates a [StateBuilder] with the provided [build] function and [uniqueKey].
  StateBuilder({required this.uniqueKey, required this.build});
}

/// Internal representation of a stored state, containing a unique key
/// and the state value itself.
class BuildState<T> {
  final UniqueKey uniqueKey;
  final T state;

  /// Constructs a [BuildState] with a unique identifier and associated value.
  BuildState({required this.uniqueKey, required this.state});
}

/// A reactive state holder that can be externally updated and refreshed.
///
/// Ideal for state that does not need an initial value at creation time.
/// The state is null-safe but must be initialized via [refreshWith] or [refreshUpdate].
class ValueState<T> {
  final UniqueKey uniqueKey;

  /// Creates a new [ValueState] with an auto-generated key.
  ValueState() : uniqueKey = UniqueKey();

  /// Replaces the current state with [newState] and triggers a widget rebuild.
  void refreshWith(T newState) {
    Reactivity.lastStateKey = uniqueKey;
    Reactivity._states[uniqueKey] = BuildState<T>(
      uniqueKey: uniqueKey,
      state: newState,
    );
    Reactivity.notifier.updateState(uniqueKey);
  }

  /// Updates the current state using a functional transformer [update],
  /// which receives the previous state and returns the new one.
  void refreshUpdate(T Function(T?) update) {
    Reactivity.lastStateKey = uniqueKey;
    T? currentState = Reactivity._states[uniqueKey]?.state as T?;
    T newState = update(currentState);
    Reactivity._states[uniqueKey] = BuildState<T>(
      uniqueKey: uniqueKey,
      state: newState,
    );
    Reactivity.notifier.updateState(uniqueKey);
  }

  /// Returns the current value of this state.
  ///
  /// Throws if the state has not been set yet.
  T get data => Reactivity._states[uniqueKey]?.state as T;

  /// Associates this state with a reactive widget built using the given function.
  StateBuilder on(Widget Function(T) build) {
    return StateBuilder(
      uniqueKey: uniqueKey,
      build: (dynamic value) => build(value as T),
    );
  }
}

/// A strongly-initialized state container that must be given a value at creation.
///
/// Ensures that state is always non-null, and provides convenience methods for
/// refreshing or transforming the stored value.
class InitedState<T> {
  final UniqueKey uniqueKey;

  /// Creates and registers an initial state.
  InitedState(T initialState) : uniqueKey = UniqueKey() {
    Reactivity._states[uniqueKey] = BuildState<T>(
      uniqueKey: uniqueKey,
      state: initialState,
    );
  }

  /// Replaces the current state with [newState] and notifies listeners.
  void refreshWith(T newState) {
    Reactivity.lastStateKey = uniqueKey;
    Reactivity._states[uniqueKey] = BuildState<T>(
      uniqueKey: uniqueKey,
      state: newState,
    );
    Reactivity.notifier.updateState(uniqueKey);
  }

  /// Updates the current state using the given transformation [update].
  void refreshUpdate(T Function(T) update) {
    Reactivity.lastStateKey = uniqueKey;
    T currentState = Reactivity._states[uniqueKey]!.state as T;
    T newState = update(currentState);
    Reactivity._states[uniqueKey] = BuildState<T>(
      uniqueKey: uniqueKey,
      state: newState,
    );
    Reactivity.notifier.updateState(uniqueKey);
  }

  /// Returns the currently stored state value.
  T get data => Reactivity._states[uniqueKey]?.state as T;

  /// Associates this state with a reactive widget builder.
  StateBuilder on(Widget Function(T) build) {
    return StateBuilder(
      uniqueKey: uniqueKey,
      build: (dynamic value) => build(value as T),
    );
  }
}

/// A special type of state that holds no value but still triggers rebuilds.
///
/// Useful for imperative widget refreshes or stateless actions.
class VoidState {
  final UniqueKey uniqueKey;

  /// Creates a new void state.
  VoidState() : uniqueKey = UniqueKey();

  /// Triggers a rebuild for widgets associated with this state.
  void refresh() {
    Reactivity.lastStateKey = uniqueKey;
    Reactivity.notifier.updateState(uniqueKey);
  }

  /// Binds this state to a widget builder that runs when refreshed.
  StateBuilder on(Widget Function() build) {
    return StateBuilder(
      uniqueKey: uniqueKey,
      build: (dynamic value) => build(),
    );
  }
}

/// Represents an empty widget used as a placeholder in reactive contexts.
///
/// Alias for [SizedBox], typically returned when no UI should be rendered.
typedef Nothing = SizedBox;
