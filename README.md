
# ⚡ reactivity

![Logo](https://raw.githubusercontent.com/felipekaian/reactivity/main/assets/logo.svg)

**A minimal and elegant state management solution for Flutter**  
_Rebuild only what matters — with zero boilerplate._

> ✅ **Built for performance**  
> 🧠 **Easy to learn**  
> 🎯 **Flutter-native**  
> 💙 **Perfect for UI-driven apps**

---

## 🧨 The Power of `ValueState` + Named Records

> The **core feature** of `reactivity` is seamless support for **Dart Records** via `ValueState`.

With `ValueState`, you manage multiple pieces of state — like `name`, `age`, `isAdmin` — using **a single named record**, with full type safety and zero boilerplate.

### 🤯 Example: Clean and Reactive

```dart
final user = ValueState<({String name, int age, bool isAdmin})>();

ReactiveState(user.on(
  (u) => Text('Name: ${u.name}, Age: ${u.age}, Admin: ${u.isAdmin}'),
));

user.refreshWith((name: 'Felipe', age: 30, isAdmin: true));
```

✔ No classes  
✔ Fully typed  
✔ Instantly reactive  
✔ Native Dart syntax

> _If you love Dart’s record syntax, this will feel like magic._

---

## ✨ Features Overview

- 🔄 `refresh()` — global rebuild trigger  
- 🧩 `Reactive`, `ReactiveState`, `ReactiveStatus`, `ReactiveShow` — declarative reactive widgets  
- 🧱 `ValueState`, `InitedState`, `VoidState` — flexible state containers  
- 🚦 `refreshStatus()` — reactive flow using enums  
- ❓ `ReactiveNullable`, `ReactiveNullableList` — handle nulls & empty states gracefully  

---

## 🚀 Getting Started

Add the dependency:

```yaml
dependencies:
  reactivity: ^1.0.0
```

Import it in your Dart file:

```dart
import 'package:reactivity/reactivity.dart';
```

---

## ⚙ Usage Examples

### Global rebuild

```dart
int counter = 0;

Reactive(() => Text('Counter: $counter'));

counter++;
refresh(); // Triggers rebuild
```

### Rebuild by key

```dart
final myKey = ReactiveKey();

Reactive(() => Text("Hello"), reactiveKey: myKey);

refreshOnly(myKey); // Rebuild just this one
```

---

## 🧱 State Containers

### `InitedState`

```dart
final name = InitedState<String>("Kaian");

ReactiveState(name.on((value) => Text("Hello $value")));

name.refreshWith("Felipe");
```

### `ValueState`

```dart
final count = ValueState<int>();

ReactiveState(count.on((value) => Text('Count: $value')));

count.refreshWith(1);
count.refreshUpdate((value) => value! + 1);
```

### `VoidState`

```dart
final trigger = VoidState();

ReactiveState(trigger.on(() => Text("Triggered!")));

trigger.refresh();
```

---

## 🚦 `ReactiveStatus`

```dart
enum Status { loading, success, error }

refreshStatus(Status.loading);

ReactiveStatus<Status>(
  cases: {
    Status.loading: () => CircularProgressIndicator(),
    Status.success: () => Text("Done!"),
    Status.error: () => Text("Oops"),
  },
  defaultCase: () => Text("Idle"),
);
```

---

## 🎭 Conditional Rendering

### `ReactiveShow`

```dart
bool isLogged = false;

ReactiveShow(
  showIf: () => isLogged,
  builder: () => Text("Welcome"),
  elseShow: Text("Login required"),
);

isLogged = true;
refresh();
```

### `ReactiveNullable`

```dart
String? username;

ReactiveNullable<String>(
  value: username,
  builder: (name) => Text("Hi $name"),
  ifNull: Text("No user"),
);

username = "Felipe";
refresh();
```

### `ReactiveNullableList`

```dart
List<String>? items;

ReactiveNullableList<String>(
  values: items,
  builder: (list) => ListView(children: list.map(Text.new).toList()),
  ifNull: CircularProgressIndicator(),
  ifEmpty: Text("No items"),
);
```

---

## ✅ Why `reactivity`?

- 🌟 First-class support for Dart **Named Records**
- 🚫 No `context`, no `classes`, no scope hassles
- 🧼 Clean and minimal API
- 💬 Declarative, expressive, and beautiful
- 🎯 Native to the Flutter widget tree

---

## 🤝 Contributing

Got ideas or found bugs?  
Feel free to open issues or submit a pull request. Let's build this together!

---

## 📄 License

MIT License © Felipe Kaian
