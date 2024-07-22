import 'dart:async';

import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  List<bool> _selections = List.generate(3, (_) => false);
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = PomodoroPage();
      case 1:
        page = Placeholder();
      case 2:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('pomodoro'),
            ToggleButtons(
              isSelected: _selections,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                  buttonIndex < _selections.length;
                  buttonIndex++) {
                    _selections[buttonIndex] = (buttonIndex == index);
                  }
                  selectedIndex = index;
                });
              },
              children: [
                Text('pomodoro'),
                Text('short break'),
                Text('long break')
              ],
            ),
            Expanded(
                child: Container(
                  child: page,
                ))
          ],
        ),
      ),
    );
  }
}

class TimerService extends ChangeNotifier{
  late Stopwatch stopwatch;
  late Timer t;
  late Function onUpdate;

  TimerService() {
    stopwatch = Stopwatch();
  }

  void startTimer() {
    stopwatch.start();
    t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      onUpdate();
    });
  }

  void stopTimer() {
    stopwatch.stop();
  }

  String formattedTime() {
    var milli = stopwatch.elapsed.inMilliseconds;
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, '0');
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class PomodoroPage extends StatefulWidget {
  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late TimerService timerService;
  @override
  void initState() {
    super.initState();
    timerService = TimerService();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Pomodoro"),
        CupertinoButton(
          child: Container(
            height: 300,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 4)),
            child: Text(
              timerService.formattedTime(),
            ),
          ),
          onPressed: () {
            if (timerService.stopwatch.isRunning) {
              timerService.stopTimer();
            } else {
              timerService.startTimer();
            }
            setState(() {
              timerService.stopwatch.isRunning = !timerService.stopwatch.isRunning;
            });

          },
        ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
