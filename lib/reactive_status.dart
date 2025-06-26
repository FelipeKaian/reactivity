import 'package:flutter/material.dart';
import 'reactivity.dart';

/// A widget that conditionally renders content based on the current reactive status of type [T].
///
/// It listens to global status changes triggered by [refreshStatus], and builds
/// the corresponding widget defined in [cases]. If the current status is not handled,
/// it falls back to [defaultCase] or renders an empty widget.
///
/// Useful for managing reactive UI flow based on enum-like states.
///
/// ### Example:
/// ```dart
/// enum MyStatus { loading, success, error }
///
/// ReactiveStatus<MyStatus>(
///   cases: {
///     MyStatus.loading: () => CircularProgressIndicator(),
///     MyStatus.success: () => Text("Done!"),
///     MyStatus.error: () => Text("Oops!"),
///   },
///   defaultCase: () => Text("Idle"),
/// )
///
/// // Somewhere else:
/// refreshStatus(MyStatus.loading);
/// ```
class ReactiveStatus<T> extends StatefulWidget {
  /// Creates a [ReactiveStatus] widget that reacts to changes in the global status of type [T].
  ///
  /// [cases] must be provided to map each status to a widget builder.
  /// If [reactiveKey] is not provided, it defaults to the runtime type of [T].
  ReactiveStatus(
    this.cases, {
    super.key,
    this.defaultCase,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? ValueKey(T);

  /// A map of status values to widget builder functions.
  ///
  /// When the current status matches a key in this map, the corresponding
  /// builder function is used to construct the widget.
  final Map<T, Widget Function()> cases;

  /// A fallback builder used when no case matches the current status.
  ///
  /// If null, a [SizedBox] (empty widget) is shown.
  final Widget Function()? defaultCase;

  /// The key used to subscribe this widget to status updates.
  ///
  /// Defaults to [ValueKey] of type [T].
  final Key reactiveKey;

  @override
  State<ReactiveStatus<T>> createState() => _ReactiveStatus<T>();
}

class _ReactiveStatus<T> extends State<ReactiveStatus<T>> {
  /// Unique key used internally to identify this widget's subscription.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Register this state to listen for updates tied to the provided reactiveKey.
    Reactivity.notifier.addUpdate(widget.reactiveKey, _uniqueKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current global status of type T.
    T status = getStatus<T>();

    // If there's a widget builder defined for this status, return it.
    if (widget.cases.containsKey(status)) {
      return widget.cases[status]!();
    }

    // Otherwise, return the fallback widget or an empty box.
    return widget.defaultCase?.call() ?? Nothing();
  }

  @override
  void dispose() {
    // Unsubscribe this state to avoid memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey, _uniqueKey);
    super.dispose();
  }
}
