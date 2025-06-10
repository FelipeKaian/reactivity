import 'package:flutter/material.dart';
import 'reactive_manager.dart';

/// A conditional reactive widget that rebuilds based on changes tracked by [Reactivity].
///
/// [ReactiveShow] allows conditionally displaying a widget depending on an optional
/// `showIf` function, and auto-registers itself with the [Reactivity] system for updates.
class ReactiveShow extends StatefulWidget {
  /// Creates a [ReactiveShow] widget.
  ///
  /// - [keys] are used to associate this widget with reactive updates.
  /// - [builder] defines the widget to show if `showIf` is `true` (or `null`).
  /// - [elseShow] is shown when `showIf` is `false`.
  ReactiveShow({
    super.key,
    this.keys = const [Null],
    this.elseShow = const SizedBox(),
    this.showIf,
    required this.builder,
  });

  /// A list of values (usually enums or identifiers) this widget depends on.
  final List<dynamic> keys;

  /// Builder function used to build the visible widget when `showIf` is true.
  final Widget Function() builder;

  /// Internal unique key used to identify this widget within the [Reactivity] system.
  final Key reactiveKey = UniqueKey();

  /// Optional condition to determine whether [builder] or [elseShow] should be shown.
  final bool Function()? showIf;

  /// Widget to show when `showIf` returns `false`.
  final Widget elseShow;

  @override
  State<ReactiveShow> createState() => _ReactiveShowState();
}

class _ReactiveShowState extends State<ReactiveShow> {
  @override
  void initState() {
    super.initState();
    // Register this widget for updates in the Reactivity system.
    Reactivity.notifier.addUpdate(widget.reactiveKey, this);
  }

  /// Evaluates the [showIf] condition, defaults to true if not provided.
  bool show() {
    if (widget.showIf != null) {
      return widget.showIf!();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds the widget conditionally based on [showIf].
    return show() ? widget.builder() : widget.elseShow;
  }

  @override
  void dispose() {
    // Unregister from Reactivity system to avoid memory leaks.
    Reactivity.notifier.removeUpdate(widget.reactiveKey);
    super.dispose();
  }
}
