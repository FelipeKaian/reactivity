// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class St8Notifier {
  Map<Key, Function()> updates;
  Key? dependency;
  St8Notifier({required this.updates, this.dependency});
  void updateDependencies() {
    updates.forEach((key, update) {
      update();
    });
  }
}
