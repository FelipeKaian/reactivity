// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:st8/st8.dart';
import 'package:st8/st8_reactive.dart';

class MyController {
  int count = 0;

  increment() {
    count++;
    refresh();
  }
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});

  MyController myController = MyController();

  @override
  Widget build(BuildContext context) {
    return Reactive(() => TextButton(
          onPressed: myController.increment,
          child: Text(myController.count.toString()),
        ));
  }
}
