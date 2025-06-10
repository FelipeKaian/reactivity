# reactivity

A minimal and powerful reactive state manager for Flutter, built around a singleton pattern with global status tracking.  
`reactivity` lets you rebuild widgets by key, manage global states with enums, and conditionally render UI with zero boilerplate.

> ⚡ Fast to learn, simple to use, and flexible for complex apps.

---

## ✨ Features

- `refresh([key])`: Rebuilds a widget by `ReactiveKey`, or all if `key == null`.
- `refreshOnly(key)`: Refreshes a specific reactive widget.
- `refreshAll()`: Refreshes all reactive widgets.
- `refreshStatus(status)`: Updates a global status and refreshes related widgets.
- `setStatus(status)`: Sets a global enum status without refreshing.
- `statusOf(Type)`: Returns the current value of a tracked status.
- Widgets:
  - `Reactive`: Makes any widget rebuildable on-demand.
  - `ReactiveStatus`: Switch-case reactive widget for enums.
  - `ReactiveShow`: Conditionally shows widgets with reactive logic.

---

## 🚀 Getting started

No setup required. Just install the package and use:

```yaml
dependencies:
  reactivity: ^1.0.0
```

Import the library where needed:

```dart
import 'package:reactivity/reactivity.dart';
```

---

## 🧪 Usage

### 1. Define an enum

```dart
enum ExampleStatus {
  loading,
  success,
  fail,
}
```

### 2. Create a controller

```dart
class MyController {
  List<String> myExamples = [];
  int counter = 0;

  void fetchExamples() {
    setStatus(ExampleStatus.loading);
    Future.delayed(const Duration(seconds: 1)).then((_) {
      myExamples = ['A', 'B', 'C'];
      refreshStatus(ExampleStatus.success);
    }).catchError((err) {
      refreshStatus(ExampleStatus.fail);
    });
  }

  void increment() {
    counter++;
    refresh();
  }
}
```

### 3. Build the reactive UI

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = MyController();

  @override
  void initState() {
    super.initState();
    controller.fetchExamples();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Reactive(() => Text("Counter: ${controller.counter}")),
      ),
      body: ReactiveStatus<ExampleStatus>({
        ExampleStatus.success: () => ListView(
              children: controller.myExamples
                  .map((e) => ListTile(title: Text(e)))
                  .toList(),
            ),
        ExampleStatus.fail: () => const Center(child: Text("Fail :(")),
        ExampleStatus.loading: () => const Center(child: CircularProgressIndicator()),
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

## 📫 Author

Created by **Felipe Kaian**  
📧 felipekaianmutti@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/felipekaian)

Feel free to contribute, suggest improvements, or report issues.  
Let’s grow the Flutter community together! 🚀