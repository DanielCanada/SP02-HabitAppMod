import 'package:hive/hive.dart';
import 'package:habittrackerapp/models/habits.dart';

class Boxes {
  static Box<Habits> getHabits() => Hive.box<Habits>('habits');
}
