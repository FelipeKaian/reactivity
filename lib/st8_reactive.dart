import 'package:flutter/material.dart';
import 'st8.dart';
import 'st8_notifier.dart';

class Reactive extends StatefulWidget {
  Reactive(
      {super.key,
      this.bindDependencies = const [Null],
      this.elseShow = const SizedBox(),
      this.showIf,
      required this.builder});

  final List<dynamic> bindDependencies;
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
