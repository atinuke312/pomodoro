
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




  void getPomodoro(){

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
    switch(selectedIndex){
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
              onPressed: (int index){
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < _selections.length; buttonIndex++) {
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

class PomodoroPage extends StatefulWidget{
  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late Stopwatch stopwatch;
  late Timer t;

  void handleStartStop(){
    if(stopwatch.isRunning){
      stopwatch.stop();
    } else {
      stopwatch.start();
    }
  }



  @override
  void initState(){
    super.initState();
    stopwatch = Stopwatch();

    t = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });

  }


  String returnFormattedText(){
    var milli = stopwatch.elapsed.inMilliseconds;

    String seconds = ((milli ~/ 1000) % 60).toString();
    String minutes = ((milli ~/ 1000) ~/ 60).toString();

    return "$minutes:$seconds";
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text("pomodoro"),
        CupertinoButton(
            child: Container (
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black,
                        width: 4
                    )
                ),
                child: Text(
                  returnFormattedText(),

                ))


            , onPressed: () {
          handleStartStop();
        }),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed:(){
          Navigator.pop(context, SettingsPage());
    }

    )


      ],

    );
  }
}

class SettingsPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Text("pomodoro")
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();


    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

            ],
          ),
        ],
      ),
    );
  }
}


