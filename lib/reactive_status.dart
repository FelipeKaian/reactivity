import 'package:flutter/material.dart';
import 'reactive_manager.dart';

/// A reactive widget that displays different UI depending on the current status of a given type [T].
///
/// The [ReactiveStatus] widget listens to changes in the enum status stored in [Reactivity].
/// It rebuilds automatically when the associated status is updated.
class ReactiveStatus<T> extends StatefulWidget {
  /// Creates a [ReactiveStatus] widget.
  ///
  /// - [cases] is a map of enum values to widget builders.
  /// - [defaultCase] is used if no matching enum case is found.
  ReactiveStatus(
    this.cases, {
    super.key,
    this.defaultCase,
  });

  /// A map that associates enum values of type [T] with widget builders.
  final Map<T, Widget Function()> cases;

  /// Optional fallback widget builder when no match is found in [cases].
  final Widget Function()? defaultCase;

  /// A reactive key uniquely identifying this status type.
  final Key reactiveKey = ValueKey(T);

  @override
  State<ReactiveStatus<T>> createState() => _ReactiveStatus<T>();
}

class _ReactiveStatus<T> extends State<ReactiveStatus<T>> {
  @override
  void initState() {
    super.initState();
    // Register this widget to be updated when status of type [T] changes.
    Reactivity.notifier.addUpdate(widget.reactiveKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current status of type [T].
    dynamic status = Reactivity.statusOf(T);

    // If a valid status is found and it matches a case, render that widget.
    if (status != null) {
      if (widget.cases.containsKey(status)) {
        return widget.cases[status]!();
      }
    }

    // If no match, fallback to the default case or an empty widget.
    return widget.defaultCase?.call() ?? SizedBox();
  }

  @override
  void dispose() {
    // Unregister from Reactivity system to avoid memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey);
    super.dispose();
  }
}
