import 'package:flutter/material.dart';
import 'reactive_manager.dart';

class ReactiveShow extends StatefulWidget {
  ReactiveShow(
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
  State<ReactiveShow> createState() => _ReactiveShowState();
}

class _ReactiveShowState extends State<ReactiveShow> {
  @override
  void initState() {
    super.initState();
    Reactives.notifier.updates.add(() {
      if (mounted) setState(() {});
    });
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
    Reactives.notifier.updates.remove(widget.builder);
    super.dispose();
  }
}
