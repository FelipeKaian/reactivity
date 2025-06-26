import 'package:flutter/material.dart';
import 'reactivity.dart';

/// A conditional reactive widget that rebuilds when the associated [reactiveKey] is triggered.
///
/// [ReactiveShow] allows you to conditionally render a widget based on the result
/// of a [showIf] predicate. When [showIf] returns `true`, [builder] is shown;
/// otherwise, [elseShow] is rendered (defaults to [Nothing]).
///
/// It listens to changes via [refresh] or [refreshOnly] using the provided [reactiveKey].
///
/// ---
///
/// ### Example:
/// ```dart
/// bool isLoggedIn = false;
///
/// ReactiveShow(
///   showIf: () => isLoggedIn,
///   builder: () => Text("Welcome back!"),
///   elseShow: Text("Please sign in"),
/// )
///
/// // Later...
/// isLoggedIn = true;
/// refresh(); // Rebuilds the widget to reflect the new condition.
/// ```
class ReactiveShow extends StatefulWidget {
  /// Creates a conditional reactive widget.
  ///
  /// [builder] is shown when [showIf] evaluates to true. Otherwise, [elseShow] is rendered.
  /// If [reactiveKey] is not provided, it defaults to a generic reactive key.
  ReactiveShow({
    super.key,
    this.elseShow = const Nothing(),
    this.showIf,
    required this.builder,
    Key? reactiveKey,
  }) : reactiveKey = reactiveKey ?? ValueKey(ReactivityTypeEnum.reactive);

  /// The widget builder shown when [showIf] returns true.
  final Widget Function() builder;

  /// A predicate that determines whether [builder] or [elseShow] is rendered.
  ///
  /// If null, defaults to always showing [builder].
  final bool Function()? showIf;

  /// The fallback widget shown when [showIf] returns false.
  ///
  /// Defaults to [Nothing], which is an alias for [SizedBox].
  final Widget elseShow;

  /// The reactive key this widget listens to.
  ///
  /// Use this key with [refreshOnly] to trigger an update.
  final Key reactiveKey;

  @override
  State<ReactiveShow> createState() => _ReactiveShowState();
}

class _ReactiveShowState extends State<ReactiveShow> {
  /// Unique identifier for managing this widget’s subscription.
  final UniqueKey _uniqueKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    // Subscribe to updates for this reactive key.
    Reactivity.notifier.addUpdate(widget.reactiveKey, _uniqueKey, this);
  }

  /// Evaluates the show condition.
  ///
  /// If [showIf] is null, defaults to true.
  bool show() {
    if (widget.showIf != null) {
      return widget.showIf!();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Render builder or elseShow based on condition.
    return show() ? widget.builder() : widget.elseShow;
  }

  @override
  void dispose() {
    // Unsubscribe from notifier updates.
    Reactivity.notifier.removeUpdate(widget.reactiveKey, _uniqueKey);
    super.dispose();
  }
}
