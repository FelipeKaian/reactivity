# ⚡ reactivity

![Logo](https://raw.githubusercontent.com/felipekaian/reactivity/main/assets/logo.svg)

A minimal and elegant state management solution for Flutter.  
Rebuild only what matters — with zero boilerplate.

> ✅ Built for performance  
> 🧠 Easy to learn  
> 🎯 Fully compatible with Flutter's widget tree  
> 💙 Ideal for UI-driven apps

---

## 🧨 The Power of `ValueState` + Dart Records

> The **biggest highlight** of `reactivity` is its seamless support for **Dart Records** via `ValueState`.

With `ValueState`, you can manage multiple related state variables — like name, age, and email — using a single named record.

### 🤯 Goodbye boilerplate, hello Named Records!

```dart
final user = ValueState<({String name, int age, bool isAdmin})>();

ReactiveState(user.on(
  (u) => Text('Name: ${u.name}, Age: ${u.age}, Admin: ${u.isAdmin}'),
));

user.refreshWith((name: 'Felipe', age: 30, isAdmin: true));
```

✔️ No classes  
✔️ Fully typed  
✔️ Instantly reactive  
✔️ Native Dart syntax

If you love Dart's `record` syntax — especially named records — this will feel like magic.

---

## ✨ Features

- 🔄 `refresh()` — triggers rebuilds globally or by key
- 🚦 `refreshStatus()` — reactive flow based on enum-like global status
- 🧱 `ValueState`, `InitedState`, `VoidState` — simple state containers with builder linkage
- 🧩 `Reactive`, `ReactiveStatus`, `ReactiveState`, `ReactiveShow` — widgets that rebuild declaratively
- ❓ `ReactiveNullable`, `ReactiveNullableList` — null-safe conditionals with expressive UI fallback

---

## 🧠 Getting Started

Add the dependency:

```yaml
dependencies:
  reactivity: ^1.0.0
```

Import in your Dart code:

```dart
import 'package:reactivity/reactivity.dart';
```

---

## 🚀 Usage

### Reactive widget (global rebuild)

```dart
int counter = 0;

Reactive(() => Text('Counter: $counter'));

// later
counter++;
refresh();
```

### Reactive key (rebuild one widget only)

```dart
final myKey = ReactiveKey();

Reactive(
  () => Text("Hello"),
  reactiveKey: myKey,
);

// later
refreshOnly(myKey);
```

---

## 🧱 Other State Tools

### InitedState

```dart
final name = InitedState<String>("Kaian");

ReactiveState(name.on((value) => Text("Hello $value")));

// Update
name.refreshWith("Felipe");
```

### ValueState (primitive or nullable types)

```dart
final count = ValueState<int>();

ReactiveState(count.on((value) => Text('Count: $value')));

// Initialize or update
count.refreshWith(1);
count.refreshUpdate((value) => value! + 1);
```

### VoidState (no data, just trigger)

```dart
final trigger = VoidState();

ReactiveState(trigger.on(() => Text("Triggered!")));

// Trigger it
trigger.refresh();
```

---

## 🚦 ReactiveStatus

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

## 🎭 Conditional builders

### ReactiveShow

```dart
bool isLogged = false;

ReactiveShow(
  showIf: () => isLogged,
  builder: () => Text("Welcome"),
  elseShow: Text("Login required"),
);

// Later
isLogged = true;
refresh();
```

### ReactiveNullable

```dart
String? username;

ReactiveNullable<String>(
  value: username,
  builder: (name) => Text("Hi $name"),
  ifNull: Text("No user"),
);

// Update
username = "Felipe";
refresh();
```

### ReactiveNullableList

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

## ✅ Why use `reactivity`?

- 🌟 Best-in-class support for Dart **Named Records**
- 🧼 Simple, focused API
- 🚫 No context, no classes, no scopes
- 🎯 Works with Flutter’s widget tree naturally
- 💬 Declarative, explicit, beautiful

---

## 💬 Contributing

Feel free to open issues, suggest features or contribute pull requests.

---

## 🧾 License

MIT License © Felipe Kaian