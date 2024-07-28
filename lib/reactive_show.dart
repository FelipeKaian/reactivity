import 'package:flutter/material.dart';
import 'reactive_manager.dart';

class ReactiveShow extends StatefulWidget {
  const ReactiveShow(
    this.builder, {
    super.key,
    this.listenKeys = const [null],
    this.elseShow = const SizedBox(),
  });

  final List<dynamic> listenKeys;
  final Widget? Function() builder;
  final Widget elseShow;

  @override
  State<ReactiveShow> createState() => _ReactiveShowState();
}

class _ReactiveShowState extends State<ReactiveShow> {
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
    return widget.builder() ?? widget.elseShow;
  }

  @override
  void dispose() {
    Reactives.disposeReactiveWidget(widget.listenKeys, update);
    super.dispose();
  }
}
