library reactive;

import 'dart:collection';
import 'reactive_notifier.dart';

class Reactives {
  static final SplayTreeMap<Type, dynamic> _status = SplayTreeMap();
  static SplayTreeMap<dynamic, ReactiveNotifier> notifiers = SplayTreeMap();

  static void refresh() {
    notifiers[null]?.updateDependencies();
  }

  static void refreshOnly(dynamic key) {
    notifiers[key]?.updateDependencies();
  }

  static dynamic statusOf(Type key) {
    return _status[key];
  }

  static void initStatus(dynamic status) {
    _status[status.runtimeType] = status;
  }

  static void refreshStatus(dynamic status) {
    _status[status.runtimeType] = status;
    refreshOnly(status.runtimeType);
  }

  static void refreshStatusOnly(dynamic status,dynamic key) {
    _status[status.runtimeType] = status;
    refreshOnly(key);
  }

  static void initReactiveWidget(List<dynamic> listenKeys, Function update) {
    for (var key in listenKeys) {
      Reactives.notifiers[key]?.updates.add(update);
    }
  }

  static void disposeReactiveWidget(List<dynamic> listenKeys, Function update) {
    for (var key in listenKeys) {
      Reactives.notifiers[key]?.updates.remove(update);
    }
  }
}

void refresh() {
  Reactives.refresh();
}

void initStatus(dynamic status) {
  Reactives.initStatus(status);
}

void refreshStatus(dynamic status) {
  Reactives.refreshStatus(status);
}
