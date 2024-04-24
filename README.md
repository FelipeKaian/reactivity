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

O St8 é um gerenciador de estado dinâmico fundamentado em Singleton que permite o gerenciamento de 
variáveis de forma global e uma grande integração com o flutter_secure_storage o que posibilita uma
extrema facilidade e praticidade na persistência de dados do seu app, como cache, tokens, informações
que são utilizadas a todo momento e que agora serão facilmete acessivéis. A curva de aprendizado é muito
curta assim como a implementação, mas ainda assim é possível realizar implementações mais robutas que 
resultam em um maior controle e em uma maior performance.
## Features

refresh(dynamic dependency):
Notifica um ouvinte específico para atualizar seu estado.

refreshAll():
Notifica todos os ouvintes para atualizar seus estados.

statusOf(String key):
Retorna o status de um Worker.

setStatus(String key, dynamic status):
Define o status de um Worker.

set(String key, dynamic value):
Define um valor associado a uma key no St8 e retorna uma referência para essa key.

make(String key, Function(dynamic) maker):
Cria um valor usando uma função maker para uma key no St8 e retorna uma referência para essa key.

get(String key):
Obtém o valor associado a uma key no St8.

getAs<T extends Object>(String key):
Obtém e converte o valor associado a uma key no St8 para o tipo especificado T.

store(String key, dynamic value):
Armazena um valor no dispositivo usando flutter_secure_storage.

loadStore<T extends Object>(List<dynamic> keys)
Recupera valores armazenados no dispositivo e atualiza o St8 com esse valor.

fromStore<T extends Object>(String key):
Recupera um valor armazenado no dispositivo e atualiza o St8 com esse valor.

free(String key):
Remove uma key e seu valor do St8.

ref(String key):
Retorna uma referência para uma key no St8.

clear():
Remove todos os valores do St8.

clearWithout(List<String> keys):
Remove todos os valores do St8, exceto os especificados na lista keys`.

lock(String key):
Bloqueia uma key específica para evitar alterações.

unlock(String key):
Desbloqueia uma key anteriormente bloqueada.

on(String key, Function(dynamic params, Function(dynamic) setStatus) work):
Define um trabalho a ser executado para uma key no St8.

off(String key):
Remove um trabalho associado a uma key no St8.

call(String key, {dynamic params}):
Executa o trabalho associado a uma key no St8 e atualiza o status.

caller(String key, {dynamic params}):
Retorna uma função que pode ser usada para executar o trabalho associado a uma key no St8.

bind(dynamic obj):
Retorna a instância Singleton de um objeto.

dispose(dynamic obj):
Remove a instância Singleton de um objeto.

## Getting started

O St8 não necessita de setup apenas instale o package e use onde precisar! :)

## Usage

```dart

enum MyGlobals { token, userName, userId }

enum MyAction {
  absent,
  loading,
  sucess,
  fail,
}

class MyController {
  List<String> myExamples = [];
  int counter = 0;

  login() {
    return Restify.get<String>("/login").then((token) {
      St8.set(MyGlobals.token,token).store(); //token salvo no Local Storage e disponivél globalmente
    });
  }

  myFunction() {
    setStatus(MyAction.loading);
    return Restify.get("/examples", bearerToken: St8.get(MyGlobals.token)) //token pego das variavéis globais
        .then((examples) {
      myExamples = examples;
      setStatus(MyAction.sucess); //status da requisição alterado para sucesso e atualiza os componentes de tela reativos
    }).catchError((err) {
      setStatus(MyAction.fail); //status da requisição alterado para falha e atualiza os componentes de tela reativos
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
  MyController myController = St8.bind(MyController()); //gera e retorna uma instância singleton do seu controller

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
      body: ReactiveStatus<MyAction>(// pertime que a tela seja reativa e que altere seus componentes com base no status
        {
          MyAction.sucess: () => ListView(
              children: myController.myExamples.map((e) => Text(e)).toList()),
          MyAction.fail: () => const Text(" fail :( "),
          MyAction.loading: () => const CircularProgressIndicator(),
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
