import 'package:flutter/material.dart';
import 'reactive_manager.dart';

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
    Reactives.notifier.updates.add(() {
      if (mounted) setState(() {});
    });
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
    super.dispose();
  }
}
