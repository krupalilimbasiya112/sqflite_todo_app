// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModalAdapter extends TypeAdapter<TaskModal> {
  @override
  final int typeId = 1;

  @override
  TaskModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModal(
      id: fields[0] as int?,
      title: fields[1] as String?,
      description: fields[2] as String?,
      isCompleted: fields[3] as int?,
      date: fields[4] as String?,
      startTime: fields[5] as String?,
      endTime: fields[6] as String?,
      remind: fields[7] as String?,
      repeat: fields[9] as String?,
      isTaskCompleted: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModal obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.startTime)
      ..writeByte(6)
      ..write(obj.endTime)
      ..writeByte(7)
      ..write(obj.remind)
      ..writeByte(9)
      ..write(obj.repeat)
      ..writeByte(10)
      ..write(obj.isTaskCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
