import 'package:flutter/material.dart';
import 'reactivity.dart';

/// A widget that rebuilds itself when notified via [refresh] or [refreshOnly].
///
/// This is the core reactive widget of the library. It subscribes itself
/// to a [ReactiveKey] and rebuilds when [Reactivity.notifier] triggers updates
/// associated with that key.
///
/// ### Example
/// ```dart
/// Reactive(() => Text('Count: $count'));
/// ```
///
/// If you want to refresh only a specific instance:
/// ```dart
/// final myKey = ReactiveKey();
///
/// Reactive(
///   () => Text('Hello'),
///   reactiveKey: myKey,
/// );
///
/// refreshOnly(myKey);
/// ```
class Reactive extends StatefulWidget {
  /// Creates a reactive widget using the given [builder] function.
  ///
  /// The [reactiveKey] determines which update notifications this widget listens to.
  /// If omitted, a default key is used based on [ReactivityTypeEnum.reactive].
  Reactive(
    this.builder, {
    super.key,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? ValueKey(ReactivityTypeEnum.reactive);

  /// The function used to build the widget tree when this widget is rebuilt.
  final Widget Function() builder;

  /// The key that identifies this reactive subscription.
  ///
  /// Use this key with [refreshOnly] or [refresh] to trigger a rebuild.
  final Key reactiveKey;

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  /// Internally used to uniquely identify this subscription within the notifier.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Register this state object to listen for updates tied to [reactiveKey].
    Reactivity.notifier.addUpdate(widget.reactiveKey, _uniqueKey, this);
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget using the provided builder function.
    return widget.builder();
  }

  @override
  void dispose() {
    // Clean up and remove the subscription to avoid memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey, _uniqueKey);
    super.dispose();
  }
}
