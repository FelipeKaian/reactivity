class ReactiveNotifier {
  List<Function()> updates;
  ReactiveNotifier({required this.updates});
  void updateDependencies() {
    for (var update in updates) {
      update();
    }
  }
}
