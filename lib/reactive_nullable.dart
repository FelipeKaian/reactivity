import 'package:flutter/material.dart';
import 'reactivity.dart';

/// A reactive widget that conditionally renders based on whether [value] is null or not.
///
/// When [value] is non-null, [builder] is used to build the widget using the value.
/// When [value] is null, [ifNull] is rendered instead (defaults to [Nothing]).
///
/// This widget listens to a [reactiveKey] and rebuilds when notified via [refresh] or [refreshOnly].
///
/// ---
///
/// ### Example:
/// ```dart
/// String? username;
///
/// ReactiveNullable<String>(
///   value: username,
///   builder: (name) => Text("Hello $name"),
///   ifNull: Text("Please login"),
/// )
///
/// // Later...
/// username = "Felipe";
/// refresh();
/// ```
class ReactiveNullable<T> extends StatefulWidget {
  /// Creates a reactive widget that responds to nullability of a value.
  ///
  /// If [value] is not null, [builder] is called with the value.
  /// If [value] is null, [ifNull] is rendered instead.
  ///
  /// If [reactiveKey] is not provided, it defaults to [ReactivityTypeEnum.reactive].
  ReactiveNullable({
    super.key,
    this.value,
    this.ifNull = const Nothing(),
    required this.builder,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? ValueKey(ReactivityTypeEnum.reactive);

  /// The nullable value to evaluate at build time.
  ///
  /// When this value is non-null, the [builder] is invoked with it.
  final T? value;

  /// Builder that is called when [value] is non-null.
  final Widget Function(T) builder;

  /// Widget shown when [value] is null.
  ///
  /// Defaults to [Nothing], which renders an empty widget.
  final Widget ifNull;

  /// Key used to determine when to trigger rebuilds.
  ///
  /// Used with [refresh] or [refreshOnly].
  final Key reactiveKey;

  @override
  State<ReactiveNullable> createState() => _ReactiveNullableState();
}

class _ReactiveNullableState extends State<ReactiveNullable> {
  /// Internal key to manage subscription to the notifier.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Register this widget to receive rebuild updates.
    Reactivity.notifier.addUpdate(widget.reactiveKey, _uniqueKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Conditionally build widget based on nullability of value.
    return widget.value != null
        ? widget.builder(widget.value!)
        : widget.ifNull;
  }

  @override
  void dispose() {
    // Clean up subscription to prevent memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey, _uniqueKey);
    super.dispose();
  }
}
