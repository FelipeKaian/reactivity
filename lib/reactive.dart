import 'package:flutter/material.dart';
import 'reactive_manager.dart';

/// A widget that rebuilds itself when triggered by a reactive update.
///
/// [Reactive] allows any widget subtree to be rebuilt by calling `refresh(key)`
/// where [key] is the same as this widget's [reactiveKey].
class Reactive extends StatefulWidget {
  /// Creates a [Reactive] widget.
  ///
  /// - [builder] is the widget builder function.
  /// - [reactiveKey] is an optional custom key for identifying this widget in [Reactivity].
  ///   If not provided, a [UniqueKey] is generated.
  Reactive(
    this.builder, {
    super.key,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? UniqueKey();

  /// The widget builder function.
  final Widget Function() builder;

  /// The key used by the [Reactivity] system to track and update this widget.
  final Key reactiveKey;

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  @override
  void initState() {
    super.initState();
    // Register this widget in the Reactivity system.
    Reactivity.notifier.addUpdate(widget.reactiveKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Simply builds the widget using the provided builder.
    return widget.builder();
  }

  @override
  void dispose() {
    // Unregister from Reactivity to avoid memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey);
    super.dispose();
  }
}
