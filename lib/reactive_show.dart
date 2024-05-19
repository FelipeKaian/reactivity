import 'package:flutter/material.dart';
import 'reactive_manager.dart';
import 'reactive_notifier.dart';

class Reactive extends StatefulWidget {
  Reactive(
      {super.key,
      this.keys = const [Null],
      this.elseShow = const SizedBox(),
      this.showIf,
      required this.builder});

  final List<dynamic> keys;
  final Widget Function() builder;
  final Key watcherKey = UniqueKey();
  final bool Function()? showIf;
  final Widget elseShow;

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

  bool show() {
    if (widget.showIf != null) {
      return widget.showIf!();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return show() ? widget.builder() : widget.elseShow;
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
