import 'st8.dart';

class St8Controller {
  void refresh() {
    St8.refresh(this);
  }

  void setStatus(dynamic status) {
    St8.setStatus(status);
    St8.refresh(this);
  }

  dynamic statusOf(dynamic key) {
    return St8.statusOf(key);
  }
}
