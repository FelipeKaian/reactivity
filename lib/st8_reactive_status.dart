import 'package:flutter/material.dart';
import 'st8.dart';
import 'st8_notifier.dart';

class ReactiveStatus<T> extends StatefulWidget {
  ReactiveStatus(this.cases,
      {super.key, this.bindDependencies = const [Null], this.defaultCase});

  final Map<T, Widget Function()> cases;
  final Widget Function()? defaultCase;
  final List<dynamic> bindDependencies;
  final Key watcherKey = UniqueKey();

  @override
  State<ReactiveStatus<T>> createState() => _ReactiveStatus<T>();
}

class _ReactiveStatus<T> extends State<ReactiveStatus<T>> {
  @override
  void initState() {
    super.initState();
    for (dynamic bind in widget.bindDependencies) {
      St8Notifier? notifier = St8.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<ReactiveStatus>() == null) {
          notifier.updates[widget.watcherKey] = () => setState(() {});
        }
      } else {
        St8.notifiers[ObjectKey(bind)] = St8Notifier(
            updates: {widget.watcherKey: () => setState(() {})},
            dependency: ObjectKey(bind));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic status = St8.statusOf(T);
    if (status != null) {
      if (widget.cases.containsKey(status)) {
        return widget.cases[status]!();
      }
    }
    return widget.defaultCase?.call() ?? Container();
  }

  @override
  void dispose() {
    for (dynamic bind in widget.bindDependencies) {
      St8Notifier? notifier = St8.notifiers[ObjectKey(bind)];
      notifier!.updates.remove(widget.watcherKey);
      if (notifier.updates.isEmpty) {
        St8.notifiers.remove(ObjectKey(bind));
      }
    }
    super.dispose();
  }
}
