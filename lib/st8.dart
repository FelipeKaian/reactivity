library st8;

import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'st8_notifier.dart';
import 'st8_reference.dart';

class St8 {
  static final SplayTreeMap<String, dynamic> _states = SplayTreeMap();
  static final SplayTreeMap<String, dynamic> _status = SplayTreeMap();
  static final SplayTreeMap<String, dynamic> _binds = SplayTreeMap();
  static final List<String> _lockedKeys = [];

  static Map<Key, St8Notifier> notifiers = {};
  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static BuildContext? context;

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
    refreshAll();
  }

  static St8Reference set(dynamic key, dynamic value) {
    key = key.toString();
    _states[key] = value;
    Type T = value.runtimeType;
    refresh(_states[key]);
    return St8Reference(key, T);
  }

  static St8Reference make(dynamic key, Function(dynamic) maker) {
    key = key.toString();
    dynamic value = maker(_states[key]);
    _states[key] = value;
    Type T = value.runtimeType;
    return St8Reference(key, T);
  }

  static dynamic get(dynamic key) {
    key = key.toString();
    return _states[key];
  }

  static T? getAs<T extends Object>(dynamic key) {
    key = key.toString();
    return _states[key] as T?;
  }

  static Future<void> store(dynamic key, dynamic value) async {
    key = key.toString();
    await storage.write(key: key, value: jsonEncode(value));
  }

  static Future<void> loadStore<T extends Object>(List<dynamic> keys) async {
    for (var key in keys) {
      key = key.toString();
      String? storeValue = await storage.read(key: key);
      if (storeValue != null) {
        T? data = jsonDecode(storeValue) as T?;
        set(key, data);
      }
    }
  }

  static Future<T?> fromStore<T extends Object>(dynamic key) async {
    key = key.toString();
    String? storeValue = await storage.read(key: key);
    if (storeValue == null) {
      return null;
    } else {
      T? data = jsonDecode(storeValue) as T?;
      set(key, data);
      return data;
    }
  }

  static Future<bool> free(dynamic key) async {
    key = key.toString();
    await storage.delete(key: key);
    return _states.remove(key);
  }

  static St8Reference use(dynamic key) {
    key = key.toString();
    Type T = get(key).runtimeType;
    return St8Reference(key, T);
  }

  static void clear() {
    _states.clear();
  }

  static void clearWithout(List<dynamic> keys) {
    keys = keys.map((key) => key.toString()).toList();
    keys.addAll(_lockedKeys);
    _states.removeWhere((key, value) => !keys.contains(key));
  }

  static void lock(dynamic key) {
    key = key.toString();
    _lockedKeys.add(key);
  }

  static void unlock(dynamic key) {
    key = key.toString();
    if (_lockedKeys.contains(key)) {
      _lockedKeys.remove(key);
    }
  }

  static bind(dynamic obj) {
    dynamic key = obj.runtimeType.toString();
    if (_binds.containsKey(key)) {
      return _binds[key];
    } else {
      _binds[key] = obj;
      return obj;
    }
  }

  static getBind(dynamic obj) {
    dynamic key = obj.runtimeType.toString();
    return _binds[key];
  }

  static dispose(dynamic obj) {
    _binds.remove(obj.runtimeType.toString());
  }

  static void navigateTo(Widget widget) {
    if (context != null) {
      Navigator.push(
          context!,
          PageRouteBuilder(
            pageBuilder: (context, a1, a2) => widget,
          ));
    } else {
      throw Exception(
          "You need do call 'St8.setContext(context);' above 'return MaterialApp(...'");
    }
  }

  static void show(Widget widget) {
    if (context != null) {
      showDialog(context: context!, builder: ((context) => widget));
    } else {
      throw Exception(
          "You need do call 'St8.setContext(context);' above 'return MaterialApp(...'");
    }
  }

  static void toNamed(String name) {
    Navigator.pushNamed(St8.get(context), name);
  }

  static void setContext(BuildContext context) {
    context = context;
  }
}

void refresh({dynamic key}) {
  St8.refresh(key);
}

void setStatus(dynamic status) {
  St8.setStatus(status);
}
