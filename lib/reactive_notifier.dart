// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ReactiveNotifier {
  Map<Key, Function()> updates;
  Key? dependency;
  ReactiveNotifier({required this.updates, this.dependency});
  void updateDependencies() {
    updates.forEach((key, update) {
      update();
    });
  }
}
