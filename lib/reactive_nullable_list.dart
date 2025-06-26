import 'package:flutter/material.dart';
import 'reactivity.dart';

/// A reactive widget that renders a UI based on a nullable list.
///
/// This widget listens to a [reactiveKey] and rebuilds when notified
/// via [refresh] or [refreshOnly]. It handles three scenarios:
///
/// - If [values] is `null`, it renders [ifNull].
/// - If [values] is empty, it renders [ifEmpty].
/// - If [values] is non-empty, it renders [builder] with the list.
///
/// Useful for conditionally rendering lists with loading and empty states.
///
/// ---
///
/// ### Example:
/// ```dart
/// List<String>? users;
///
/// ReactiveNullableList<String>(
///   values: users,
///   builder: (list) => ListView(children: list.map(Text.new).toList()),
///   ifNull: CircularProgressIndicator(),
///   ifEmpty: Text("No users found"),
/// )
///
/// // Later...
/// users = ["Alice", "Bob"];
/// refresh();
/// ```
class ReactiveNullableList<T> extends StatefulWidget {
  /// Creates a [ReactiveNullableList] that rebuilds reactively
  /// and displays different widgets depending on the state of [values].
  ReactiveNullableList({
    super.key,
    this.values,
    this.ifNull = const Nothing(),
    this.ifEmpty = const Nothing(),
    required this.builder,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? ValueKey(ReactivityTypeEnum.reactive);

  /// The list of values to evaluate and pass to [builder].
  ///
  /// May be null (e.g. before loading completes).
  final List<T>? values;

  /// Builder called when [values] is non-null and not empty.
  final Widget Function(List<T>) builder;

  /// Widget to display if [values] is null.
  ///
  /// Defaults to an empty [SizedBox].
  final Widget ifNull;

  /// Widget to display if [values] is an empty list.
  ///
  /// Defaults to an empty [SizedBox].
  final Widget ifEmpty;

  /// Key used to identify which reactive updates this widget listens to.
  final Key reactiveKey;

  @override
  State<ReactiveNullableList<T>> createState() => _ReactiveNullableState<T>();
}

class _ReactiveNullableState<T> extends State<ReactiveNullableList<T>> {
  /// Unique subscription key for this widget's lifecycle.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Register this widget to rebuild when notified via the reactive key.
    Reactivity.notifier.addUpdate(widget.reactiveKey, _uniqueKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Evaluate the state of the list and return the appropriate widget.
    if (widget.values != null) {
      if (widget.values!.isNotEmpty) {
        return widget.builder(widget.values!);
      } else {
        return widget.ifEmpty;
      }
    } else {
      return widget.ifNull;
    }
  }

  @override
  void dispose() {
    // Unsubscribe from notifications to prevent memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey, _uniqueKey);
    super.dispose();
  }
}
