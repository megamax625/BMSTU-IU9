import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const TimerPickerApp());

class TimerPickerApp extends StatelessWidget {
  const TimerPickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: TimerPickerExample(),
    );
  }
}

class TimerPickerExample extends StatefulWidget {
  const TimerPickerExample({super.key});

  @override
  State<TimerPickerExample> createState() => _TimerPickerExampleState();
}

class _TimerPickerExampleState extends State<TimerPickerExample> {
  Duration duration = const Duration(minutes: 0, seconds: 0, milliseconds: 0);
  late Stopwatch stopwatch;
  late Timer t;

  void handleStartStop() {
    if(stopwatch.isRunning) {
      stopwatch.stop();
    }
    else {
      stopwatch.start();
    }
  }

  String returnFormattedTime() {
    var milli = stopwatch.elapsed.inMilliseconds;
    String milliseconds = (milli % 1000).toString().padLeft(3, "0");
    String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0");
    String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0");
    return "$minutes:$seconds:$milliseconds";
  }

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();

    t = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cupertino Stopwatch Sample'),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Text('Timer'),
              CupertinoButton(
                onPressed: () {
                  handleStartStop();
                },
                padding: const EdgeInsets.all(12),
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,  // this one is use for make the circle on ui.
                    border: Border.all(
                      color: getBoxColor(),
                      width: 6,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: Text(returnFormattedTime(), style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              CupertinoButton(
                // Display a CupertinoTimerPicker with hour/minute mode.
                onPressed: () => {
                  stopwatch.reset(),
                  if(stopwatch.isRunning) {
                    stopwatch.stop(),
                  }
                },
                // In this example, the timer value is formatted manually. You can use intl package
                // to format the value based on user's locale settings.
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade200,
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.red.shade900,
                      width: 4,
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getBoxColor() {
    if (stopwatch.isRunning) {
      return Colors.yellow;
    } else {
      return Colors.blue;
    }
  }
}

// This class simply decorates a row of widgets.
class _TimerPickerItem extends StatelessWidget {
  const _TimerPickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
