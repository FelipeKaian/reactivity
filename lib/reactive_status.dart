import 'package:flutter/material.dart';
import 'reactive_manager.dart';
import 'reactive_notifier.dart';

class ReactiveStatus<T> extends StatefulWidget {
  ReactiveStatus(this.cases,
      {super.key, this.keys = const [Null], this.defaultCase});

  final Map<T, Widget Function()> cases;
  final Widget Function()? defaultCase;
  final List<dynamic> keys;
  final Key watcherKey = UniqueKey();

  @override
  State<ReactiveStatus<T>> createState() => _ReactiveStatus<T>();
}

class _ReactiveStatus<T> extends State<ReactiveStatus<T>> {
  @override
  void initState() {
    super.initState();
    for (dynamic bind in widget.keys) {
      ReactiveNotifier? notifier = Reactives.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<ReactiveStatus>() == null) {
          notifier.updates[widget.watcherKey] = () {
            if (mounted) setState(() {});
          };
        }
      } else {
        Reactives.notifiers[ObjectKey(bind)] = ReactiveNotifier(updates: {
          widget.watcherKey: () {
            if (mounted) setState(() {});
          }
        }, dependency: ObjectKey(bind));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic status = Reactives.statusOf(T);
    if (status != null) {
      if (widget.cases.containsKey(status)) {
        return widget.cases[status]!();
      }
    }
    return widget.defaultCase?.call() ?? Container();
  }

  @override
  void dispose() {
    for (dynamic bind in widget.keys) {
      ReactiveNotifier? notifier = Reactives.notifiers[ObjectKey(bind)];
      notifier!.updates.remove(widget.watcherKey);
      if (notifier.updates.isEmpty) {
        Reactives.notifiers.remove(ObjectKey(bind));
      }
    }
    super.dispose();
  }
}
