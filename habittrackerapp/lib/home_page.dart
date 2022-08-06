import 'package:flutter/material.dart';
import 'dart:async';
import 'package:habittrackerapp/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  List habitList = [
    ['Exercise / Chores', false, 0, 1],
    ['Meditate', false, 0, 20],
    ['Hobbies', false, 0, 20],
    ['Read', false, 0, 40],
  ];

  void habitStarted(int index) {
    // start or stop
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });
    // include time elapsed
    int elapsedTime = habitList[index][2];
    // note start time
    var startTime = DateTime.now();

    if (habitList[index][1] == true) {
      // keep time going
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          // check if stop
          if (habitList[index][1] == false) {
            timer.cancel();
          }

          // calculate time elapsed
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Settings for ' + habitList[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Consistency is key."),
          centerTitle: false,
        ),
        body: ListView.builder(
            itemCount: habitList.length,
            itemBuilder: ((context, index) {
              return HabitTile(
                  habitName: habitList[index][0],
                  onTap: () {
                    habitStarted(index);
                  },
                  settingsTapped: () {
                    settingsOpened(index);
                  },
                  timeSpent: habitList[index][2],
                  timeGoal: habitList[index][3],
                  habitStarted: habitList[index][1]);
            })));
  }
}
