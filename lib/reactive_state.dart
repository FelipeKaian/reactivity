import 'package:flutter/cupertino.dart';
import 'reactivity.dart';

/// A widget that listens to a single reactive state and rebuilds accordingly.
///
/// This widget should be used with one stateful reactive controller,
/// such as [ValueState], [InitedState], or [VoidState].
///
/// Unlike [ReactiveStates], which listens to multiple state keys,
/// [ReactiveState] listens to only one and is simpler to use for isolated updates.
///
/// ---
///
/// ### Example:
/// ```dart
/// final counter = InitedState<int>(0);
///
/// ReactiveState(
///   counter.on((value) => Text('Count: $value')),
/// );
///
/// // Later:
/// counter.refreshUpdate((count) => count + 1);
/// ```
class ReactiveState extends StatefulWidget {
  /// Creates a [ReactiveState] widget bound to a single reactive state.
  ///
  /// [stateBuilder] defines the unique key and widget-building logic.
  /// [defaultCase] is optional and shown if the state was never updated.
  const ReactiveState(
    this.stateBuilder, {
    super.key,
    this.defaultCase,
  });

  /// The builder associated with a specific state key.
  ///
  /// Generated from [ValueState.on], [InitedState.on], or [VoidState.on].
  final StateBuilder stateBuilder;

  /// A fallback widget builder if the state was never initialized or updated.
  final Widget Function()? defaultCase;

  @override
  State<ReactiveState> createState() => _ReactiveState();
}

class _ReactiveState extends State<ReactiveState> {
  /// Internal unique identifier used for subscription tracking.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Register this widget to rebuild when the specific state changes.
    Reactivity.notifier.addUpdate(
      widget.stateBuilder.uniqueKey,
      _uniqueKey,
      this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the most recently updated state value.
    BuildState? buildState = Reactivity.getLastBuildState();

    // If the current state matches, use the builder.
    if (buildState != null) {
      return widget.stateBuilder.build(buildState.state);
    }

    // If no match or uninitialized, return fallback or empty.
    return widget.defaultCase?.call() ?? const Nothing();
  }

  @override
  void dispose() {
    // Remove the subscription to avoid memory leaks.
    Reactivity.notifier.removeUpdate(
      widget.stateBuilder.uniqueKey,
      _uniqueKey,
    );
    super.dispose();
  }
}
