import 'package:flutter/material.dart';
import 'package:habittrackerapp/models/habits.dart';

class HabitDialog extends StatefulWidget {
  final Habits? habit;
  final Function(String name, int timeSpent, int timeGoal, bool habitStarted)
      onClickedDone;

  const HabitDialog({
    Key? key,
    this.habit,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _HabitDialogState createState() => _HabitDialogState();
}

class _HabitDialogState extends State<HabitDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final timeGoalController = TextEditingController();

  bool habitStarted = true;

  @override
  void initState() {
    super.initState();

    if (widget.habit != null) {
      final habit = widget.habit!;

      nameController.text = habit.name;
      timeGoalController.text = habit.timeSpent.toString();
      timeGoalController.text = habit.timeGoal.toString();
      habitStarted = habit.habitStarted;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    timeGoalController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.habit != null;
    final title = isEditing ? 'Edit Habit' : 'Consistency is key.';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildName(),
              const SizedBox(height: 8),
              buildTimeGoal(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        cursorColor: Colors.black,
        controller: nameController,
        decoration: const InputDecoration(
          labelText: "Label:",
          labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: Colors.black),
      );

  Widget buildTimeGoal() => TextFormField(
        cursorColor: Colors.black,
        controller: timeGoalController, //habitList[index][3].toString()),
        decoration: const InputDecoration(
          labelText: "Duration ( minutes ):",
          labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        ),
        validator: (timeSpent) =>
            timeSpent != null && int.tryParse(timeSpent) == null
                ? 'Enter a valid number'
                : null,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        style: const TextStyle(color: Colors.black),
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          const timeSpent = 0;
          final timeGoal = int.tryParse(timeGoalController.text) ?? 0;

          widget.onClickedDone(name, timeSpent, timeGoal, habitStarted);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
