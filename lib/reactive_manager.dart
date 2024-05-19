library reactive;

import 'dart:collection';
import 'package:flutter/material.dart';
import 'reactive_notifier.dart';

class Reactives {
  static final SplayTreeMap<String, dynamic> _status = SplayTreeMap();
  static Map<Key, ReactiveNotifier> notifiers = {};

  static void refresh(dynamic dependency) {
    if (dependency != null) {
      notifiers[ObjectKey(dependency)]?.updateDependencies();
    }
    notifiers[const ObjectKey(Null)]?.updateDependencies();
  }

  static void refreshAll() {
    refresh(Null);
  }

  static dynamic statusOf(Type key) {
    return _status[key.toString()];
  }

  static void setStatus(dynamic status) {
    _status[status.runtimeType.toString()] = status;
  }

  static void refreshStatus(dynamic status) {
    _status[status.runtimeType.toString()] = status;
    refreshAll();
  }
}

void refresh({dynamic key}) {
  Reactives.refresh(key);
}

void setStatus(dynamic status) {
  Reactives.setStatus(status);
}

void refreshStatus(dynamic status) {
  Reactives.refreshStatus(status);
}
