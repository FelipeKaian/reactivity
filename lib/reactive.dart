import 'package:flutter/material.dart';
import 'reactive_manager.dart';
import 'reactive_notifier.dart';

class Reactive extends StatefulWidget {
  Reactive({super.key, this.keys = const [Null], required this.builder});

  final List<dynamic> keys;
  final Widget Function() builder;
  final Key watcherKey = UniqueKey();

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  @override
  void initState() {
    super.initState();
    for (dynamic bind in widget.keys) {
      ReactiveNotifier? notifier = Reactives.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<Reactive>() == null) {
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
    return widget.builder();
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
