import 'package:flutter/cupertino.dart';
import 'reactivity.dart';

/// A widget that conditionally builds based on multiple reactive state updates.
///
/// This widget listens to a set of [StateBuilder]s (typically produced by [ValueState], [InitedState] or [VoidState])
/// and rebuilds when any of them is updated via `refreshWith()` or `refreshUpdate()`.
///
/// The most recently updated state will be passed to the matching builder, ensuring
/// that only the relevant state widget is rebuilt.
///
/// This is ideal when you have multiple reactive states but want a unified
/// reactive handler to build different widgets depending on *which* state was updated.
///
/// ---
///
/// ### Example:
/// ```dart
/// final name = InitedState("Felipe");
/// final age = InitedState(23);
///
/// ReactiveStates({
///   name.on((value) => Text('Name: $value')),
///   age.on((value) => Text('Age: $value')),
/// });
///
/// name.refreshWith("Kaian"); // Only the name widget will rebuild.
/// ```
///
/// If no known state was updated, [defaultCase] is rendered (if provided).
class ReactiveStates extends StatefulWidget {
  /// Creates a [ReactiveStates] widget with a set of reactive builders.
  ///
  /// Each builder in [stateBuilders] corresponds to a state that can trigger a rebuild.
  /// If [defaultCase] is provided, it is used when no matching update is found.
  const ReactiveStates(
    this.stateBuilders, {
    super.key,
    this.defaultCase,
  });

  /// A set of builders associated with unique reactive states.
  ///
  /// Each [StateBuilder] contains a [UniqueKey] and a corresponding builder function.
  final Set<StateBuilder> stateBuilders;

  /// A fallback widget builder to render if no reactive match is found.
  final Widget Function()? defaultCase;

  @override
  State<ReactiveStates> createState() => _ReactiveStates();
}

class _ReactiveStates extends State<ReactiveStates> {
  /// Internally generated key to register this widget as a subscriber.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    // Subscribe to updates for all registered state builders.
    for (final builder in widget.stateBuilders) {
      Reactivity.notifier.addUpdate(builder.uniqueKey, _uniqueKey, this);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the most recently updated state.
    BuildState? buildState = Reactivity.getLastBuildState();

    if (buildState != null) {
      // Find the builder matching the updated state key and render its widget.
      for (final builder in widget.stateBuilders) {
        if (builder.uniqueKey == buildState.uniqueKey) {
          return builder.build(buildState.state);
        }
      }
    }

    // No matching update found; fall back to default case or empty widget.
    return widget.defaultCase?.call() ?? Nothing();
  }

  @override
  void dispose() {
    // Unsubscribe from all associated builders to avoid memory leaks.
    for (final builder in widget.stateBuilders) {
      Reactivity.notifier.removeUpdate(builder.uniqueKey, _uniqueKey);
    }
    super.dispose();
  }
}
