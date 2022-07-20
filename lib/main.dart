import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fav Name',
      home: const RandomWords(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        color: Colors.white,
        foregroundColor: Colors.blue,
      )),
    );
  }
}

class Saved extends StatefulWidget {
  const Saved({super.key});
  @override
  State<Saved> createState() => _Saved();
}

class _Saved extends State<Saved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Names"),
      ),
      body: globals.saved.isEmpty
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "No Saved Names",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: Navigator.of(context).pop,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: globals.saved.length * 2,
              itemBuilder: (context, i) {
                if (i.isOdd) {
                  return const Divider();
                } else if (i == -1) {
                  return const Text("no Saved Names");
                }
                final index = i ~/ 2;

                return ListTile(
                  title: Text(
                    globals.saved[index].asPascalCase,
                    style: globals.font,
                  ),
                  trailing: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    semanticLabel: 'Remove?',
                  ),
                  onTap: () {
                    setState(() {
                      globals.saved.removeAt(index);
                    });
                  }, //on tap
                );
              }, //item builder
            ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fav Names"),
          actions: [
            IconButton(
                icon: const Icon(Icons.list),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Saved()),
                  );
                  setState(() {});
                },
                tooltip: "Saved Names"),
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return const Divider();

            final index = i ~/ 2;
            if (index >= globals.rands.length) {
              globals.rands.addAll(generateWordPairs().take(10));
            }
            final alreadySaved = globals.saved.contains(globals.rands[index]);
            return ListTile(
              title: Text(
                globals.rands[index].asPascalCase,
                style: globals.font,
              ),
              trailing: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove?' : 'Save?',
              ),
              onTap: () {
                setState(() {
                  alreadySaved
                      ? globals.saved.remove(globals.rands[index])
                      : globals.saved.add(globals.rands[index]);
                });
              }, //on tap
            );
          }, //item builder
        ));
  }
}
