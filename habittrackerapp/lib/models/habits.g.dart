// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habits.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitsAdapter extends TypeAdapter<Habits> {
  @override
  final int typeId = 0;

  @override
  Habits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habits()
      ..name = fields[0] as String
      ..timeSpent = fields[1] as int
      ..timeGoal = fields[2] as int
      ..habitStarted = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, Habits obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.timeSpent)
      ..writeByte(2)
      ..write(obj.timeGoal)
      ..writeByte(3)
      ..write(obj.habitStarted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
