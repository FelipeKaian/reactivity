import 'package:flutter/material.dart';
import 'st8.dart';
import 'st8_notifier.dart';

class Reactive extends StatefulWidget {
  Reactive(this.builder, {super.key, this.bindDependencies = const [Null]});

  final List<dynamic> bindDependencies;
  final Widget Function() builder;
  final Key watcherKey = UniqueKey();

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  @override
  void initState() {
    super.initState();
    for (dynamic bind in widget.bindDependencies) {
      St8Notifier? notifier = St8.notifiers[ObjectKey(bind)];
      if (notifier != null) {
        if (context.findAncestorWidgetOfExactType<Reactive>() == null) {
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
    return widget.builder();
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
