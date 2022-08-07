import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:habittrackerapp/models/habits.dart';

class HabitTile extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback settingsTapped;
  final VoidCallback restartTapped;
  Habits habit;

  HabitTile({
    Key? key,
    required this.onTap,
    required this.settingsTapped,
    required this.restartTapped,
    required this.habit,
  }) : super(key: key);

  // convert seconds into mini sec
  String formatToMinSec(int totalSeconds) {
    String secs = (totalSeconds % 60).toString();
    String mins = (totalSeconds / 60).toStringAsFixed(5);

    // if sec is 1 digit place 0
    if (secs.length == 1) {
      secs = '0$secs';
    }

    // if min is 1 digit
    if (mins[1] == '.') {
      mins = mins.substring(0, 1);
    }

    return "$mins:$secs";
  }

  // calculate progress percentage
  double percentCompleted() {
    return habit.timeSpent / (habit.timeGoal * 60);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        // progress circle
                        CircularPercentIndicator(
                          radius: 30,
                          percent:
                              percentCompleted() < 1 ? percentCompleted() : 1,
                          progressColor: percentCompleted() > 0.5
                              ? (percentCompleted() > 0.75
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.red,
                        ),
                        Center(
                            child: Icon(habit.habitStarted
                                ? Icons.pause
                                : Icons.play_arrow)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    // progress
                    Text(
                      percentCompleted() == 1
                          ? "Completed!"
                          : "${formatToMinSec(habit.timeSpent)} / ${habit.timeGoal} = ${(percentCompleted() * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                habit.habitStarted
                    ? const Icon(
                        Icons.timelapse_rounded,
                        color: Colors.black,
                      )
                    : GestureDetector(
                        onTap: restartTapped,
                        child: const Icon(
                          Icons.restart_alt,
                          color: Colors.red,
                        )),
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: settingsTapped, child: const Icon(Icons.settings)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
