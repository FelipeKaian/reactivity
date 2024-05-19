<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

O Reactive é um gerenciador de estado dinâmico fundamentado em Singleton que permite o gerenciamento de 
variáveis de forma global, orientada a condições, orientada a estados e principalmente de forma reativa. 
A curva de aprendizado é muitocurta assim como a implementação, mas ainda assim é possível realizar 
implementações mais robutas que resultam em um maior controle e em uma maior performance.
## Features

refresh(dynamic dependency):
Notifica um ouvinte específico para atualizar seu estado.

statusOf(String key):
Retorna o status de um Worker.

setStatus(String key, dynamic status):
Define o status de um Worker.

## Getting started

O Reactive não necessita de setup apenas instale o package e use onde precisar! :)

## Usage

```dart

enum ExampleStatus {
  loading,
  sucess,
  fail,
}

class MyController {
  List<String> myExamples = [];
  int counter = 0;

  myFunction() {
    setStatus(ExampleStatus.loading);
    return http.get("/examples")
        .then((examples) {
      myExamples = examples;
      refreshStatus(ExampleStatus.sucess); //status da requisição alterado para sucesso e atualiza os componentes de tela reativos
    }).catchError((err) {
      refreshStatus(ExampleStatus.fail); //status da requisição alterado para falha e atualiza os componentes de tela reativos
    });
  }

  count() {
    counter++;
    refresh(); //atualiza os componentes de tela reativos
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyController myController = MyController();

  @override
  void initState() {
    super.initState();
    myController.myFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Reactive(() => Text("Counter: ${myController.counter}")), // deixa o texto reativo
      ),
      body: ReactiveStatus<ExampleStatus>(// pertime que a tela seja reativa e que altere seus componentes com base no status
        {
          ExampleStatus.sucess: () => ExampleListView(items: myController.myExamples),// mostra a lista caso seja sucess
          ExampleStatus.fail: () => const Text(" fail :( "),// mostra a erro caso seja fail
          ExampleStatus.loading: () => const CircularProgressIndicator(),// mostra um ProgressIndicator caso seja loading
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: myController.count,
        child: const Icon(Icons.add),
      ),
    );
  }
}

```

## Additional information

Me chamo Felipe Kaian, sou o autor deste pacote, vocês podem me econtrar no LinkedIn ou 
através do email felipekaianmutti@gmail.com, podem trazer melhorias, sugestões e feedbacks,
quanto mais melhor, espero que esse pacote ajude nossa comunidade Flutter a crescer cada vez mais!
