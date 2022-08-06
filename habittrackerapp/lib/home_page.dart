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

          if (habitList[index][2] == ((habitList[index][3] * 60) - 1)) {
            timer.cancel();
            habitList[index][1] = !habitList[index][1];
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

  void restartClicked(int index) {
    setState(() {
      habitList[index][2] = 0;
    });
  }

  void settingsOpened(int index) {
    TextEditingController nameEditController;
    TextEditingController durationEditController;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: nameEditController =
                        TextEditingController(text: habitList[index][0]),
                    decoration: const InputDecoration(
                      //hintText: snapshot.data!.title.toString(),
                      labelText: "Label:",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Colors.black,
                    controller: durationEditController = TextEditingController(
                        text: habitList[index][3].toString()),
                    decoration: const InputDecoration(
                      //hintText: snapshot.data!.title.toString(),
                      labelText: "Duration ( minutes ):",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  setState(() {
                    habitList[index][0] = nameEditController.text;
                    habitList[index][3] =
                        double.parse(durationEditController.text);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Small Daily Habits Lead to Long Term Growth.",
              style: TextStyle(fontSize: 16)),
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
                restartTapped: () {
                  restartClicked(index);
                },
                timeSpent: habitList[index][2],
                timeGoal: habitList[index][3],
                habitStarted: habitList[index][1],
              );
            })));
  }
}
