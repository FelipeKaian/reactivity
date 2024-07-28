import 'package:flutter/material.dart';
import 'reactive_manager.dart';

class ReactiveStatus<T> extends StatefulWidget {
  const ReactiveStatus(this.cases,
      {super.key, this.listenKeys = const [null], this.defaultCase});

  final Map<T, Widget Function()> cases;
  final Widget Function()? defaultCase;
  final List<dynamic> listenKeys;

  @override
  State<ReactiveStatus<T>> createState() => _ReactiveStatus<T>();
}

class _ReactiveStatus<T> extends State<ReactiveStatus<T>> {

  update() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.listenKeys.add(T);
    Reactives.initReactiveWidget(widget.listenKeys, update);
  }

  @override
  Widget build(BuildContext context) {
    dynamic status = Reactives.statusOf(T);
    if (status != null) {
      if (widget.cases.containsKey(status)) {
        return widget.cases[status]!();
      }
    }
    return widget.defaultCase?.call() ?? const SizedBox();
  }

  @override
  void dispose() {
    Reactives.disposeReactiveWidget(widget.listenKeys, update);
    super.dispose();
  }
}
