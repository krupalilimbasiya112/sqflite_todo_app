import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'task_modal.g.dart';

@HiveType(typeId: 1)
class TaskModal {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int? isCompleted;
  @HiveField(4)
  String? date;
  @HiveField(5)
  String? startTime;
  @HiveField(6)
  String? endTime;
  @HiveField(7)
  String? remind;
  @HiveField(9)
  String? repeat;
  @HiveField(10)
  late final bool isTaskCompleted;

  TaskModal({
    this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.remind,
    this.repeat,
    required this.isTaskCompleted
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title ?? '',
      'description': description ?? '',
      'isCompleted': isCompleted ?? 0,
      'date': date ?? '',
      'startTime': startTime ?? '',
      'endTime': endTime ?? '',
      'remind': remind ?? 0,
      'repeat': repeat ?? '',
      'isTaskCompleted': isTaskCompleted ?? false,
    };
  }

  factory TaskModal.fromMap(Map<String, dynamic> map) {
    return TaskModal(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      remind: map['remind'],
      repeat: map['repeat'],
      isTaskCompleted: map['isTaskCompleted']
    );
  }
}