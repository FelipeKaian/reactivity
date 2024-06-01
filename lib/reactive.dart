import 'package:flutter/material.dart';
import 'reactive_manager.dart';

class Reactive extends StatefulWidget {
  Reactive(this.builder, {super.key});

  final Widget Function() builder;
  final Key watcherKey = UniqueKey();

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive> {
  @override
  void initState() {
    super.initState();
    Reactives.notifier.updates.add(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }

  @override
  void dispose() {
    Reactives.notifier.updates.remove(widget.builder);
    super.dispose();
  }
}
