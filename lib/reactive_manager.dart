library reactive;

import 'dart:collection';
import 'reactive_notifier.dart';

class Reactives {
  static final SplayTreeMap<String, dynamic> _status = SplayTreeMap();
  static ReactiveNotifier notifier = ReactiveNotifier(updates: []);

  static void refresh() {
    notifier.updateDependencies();
  }

  static dynamic statusOf(Type key) {
    return _status[key.toString()];
  }

  static void setStatus(dynamic status) {
    _status[status.runtimeType.toString()] = status;
  }

  static void refreshStatus(dynamic status) {
    _status[status.runtimeType.toString()] = status;
    refresh();
  }
}

void refresh() {
  Reactives.refresh();
}

void setStatus(dynamic status) {
  Reactives.setStatus(status);
}

void refreshStatus(dynamic status) {
  Reactives.refreshStatus(status);
}
