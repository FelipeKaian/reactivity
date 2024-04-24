import 'st8.dart';

class St8Reference {
  final String _key;
  final Type type;

  St8Reference(this._key, this.type);

  String get key => _key;

  set key(String newKey) {
    St8.set(_key, newKey);
  }

  get value => St8.get(_key);

  set value(dynamic newValue) {
    St8.set(_key, newValue);
  }

  St8Reference lock() {
    St8.lock(key);
    return this;
  }

  St8Reference unlock() {
    St8.unlock(key);
    return this;
  }

  St8Reference store() {
    St8.store(key, value);
    return this;
  }

  St8Reference to(dynamic newValue) {
    St8.set(key, newValue);
    return this;
  }

  St8Reference refresh() {
    St8.refresh(this);
    return this;
  }
}
