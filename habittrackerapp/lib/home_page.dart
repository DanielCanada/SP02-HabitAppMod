import 'package:flutter/material.dart';
import 'package:habittrackerapp/boxes.dart';
import 'dart:async';
import 'package:habittrackerapp/habit_tile.dart';
import 'package:habittrackerapp/widgets/habit_dialog.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:habittrackerapp/models/habits.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  @override
  void dispose() {
    Hive.close();

    super.dispose();
  }

  void habitStarted(Habits habits) {
    // start or stop
    setState(() {
      habits.habitStarted = !habits.habitStarted;
    });
    // include time elapsed
    int elapsedTime = habits.timeSpent;
    // note start time
    var startTime = DateTime.now();

    if (habits.habitStarted == true) {
      // keep time going
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          // check if stop
          if (habits.habitStarted == false) {
            timer.cancel();
          }

          if (habits.timeSpent == ((habits.timeGoal * 60) - 1)) {
            timer.cancel();
            habits.habitStarted = !habits.habitStarted;
          }

          // calculate time elapsed
          var currentTime = DateTime.now();
          habits.timeSpent = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });
      });
    }
  }

  void restartClicked(Habits habits) {
    setState(() {
      habits.timeSpent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Start Small, Grow Big.",
            style: TextStyle(fontSize: 16)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_sharp),
            tooltip: 'Information',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Simple Habit Tracker App'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text(
                            'This is a modified habit tracker app from youtube. (Habit tracker UI by Mitch Koko)\n'),
                        Text('• Slide tile to left to delete •\n'),
                        Text(
                          '©CheeseSaux',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('back'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: ValueListenableBuilder<Box<Habits>>(
        valueListenable: Boxes.getHabits().listenable(),
        builder: (context, box, _) {
          final habits = box.values.toList().cast<Habits>();

          return buildContent(habits);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: () => showDialog(
          context: context,
          builder: (context) => HabitDialog(
            onClickedDone: addHabit,
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildContent(List<Habits> habits) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Icon(Icons.auto_awesome_motion_outlined),
            const SizedBox(height: 10),
            const Text(
              'No habits yet!',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 22),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(6),
              itemCount: habits.length,
              itemBuilder: (BuildContext context, int index) {
                final habit = habits[index];

                // return buildHabit(context, habit);
                return Dismissible(
                  key: Key(habit.name),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      deleteHabit(habit);
                      habits.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${habit.name} removed'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  background: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: HabitTile(
                      onTap: () {
                        habitStarted(habit);
                      },
                      settingsTapped: () {
                        showDialog(
                            context: context,
                            builder: (context) => HabitDialog(
                                  habit: habit,
                                  onClickedDone: (name, timeSpent, timeGoal,
                                          habitStarted) =>
                                      editHabit(habit, name, timeSpent,
                                          timeGoal, habitStarted),
                                ));
                      },
                      restartTapped: () {
                        restartClicked(habit);
                      },
                      habit: habit),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildHabit(
    BuildContext context,
    Habits habit,
  ) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          habit.name,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("${habit.timeSpent}/${habit.timeGoal}"),
        children: [
          buildButtons(context, habit),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Habits habit) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: const Text('Edit'),
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HabitDialog(
                    habit: habit,
                    onClickedDone: (name, timeSpent, timeGoal, habitStarted) =>
                        editHabit(
                            habit, name, timeSpent, timeGoal, habitStarted),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: const Text('Delete'),
              icon: const Icon(Icons.delete),
              onPressed: () => deleteHabit(habit),
            ),
          )
        ],
      );

  Future? addHabit(
      String name, int timeSpent, int timeGoal, bool habitStarted) {
    final habit = Habits()
      ..name = name
      ..timeSpent = timeSpent
      ..timeGoal = timeGoal
      ..habitStarted = false;

    final box = Boxes.getHabits();
    box.add(habit);
  }

  void editHabit(
    Habits habit,
    String name,
    int timeSpent,
    int timeGoal,
    bool habitStarted,
  ) {
    habit.name = name;
    habit.timeSpent = timeSpent;
    habit.timeGoal = timeGoal;
    habit.habitStarted = habitStarted;

    // final box = Boxes.getTransactions();
    // box.put(habit.key, habit);

    habit.save();
  }

  void deleteHabit(Habits habit) {
    // final box = Boxes.getTransactions();
    // box.delete(habit.key);

    habit.delete();
    //setState(() => transactions.remove(habit));
  }
}
