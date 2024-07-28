import 'package:flutter/material.dart';
import 'reactive_manager.dart';

class Reactive extends StatefulWidget {
  const Reactive(this.builder, {super.key, this.listenKeys = const [null]});

  final Widget Function() builder;
  final List<dynamic> listenKeys;

  @override
  State<Reactive> createState() => _ReactiveState();
}

class _ReactiveState extends State<Reactive>{

  update() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Reactives.initReactiveWidget(widget.listenKeys, update);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }

  @override
  void dispose() {
    Reactives.disposeReactiveWidget(widget.listenKeys, update);
    super.dispose();
  }
}
