import 'package:hive/hive.dart';

part 'habits.g.dart';

@HiveType(typeId: 0) // unique to class
class Habits extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int timeSpent;

  @HiveField(2)
  late int timeGoal;

  @HiveField(3)
  late bool habitStarted = false;
}
