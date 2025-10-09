import 'package:flutter/material.dart';

class TaskModal {
  int? id;
  String? title;
  String? description;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  Color? color;
  String? remind;
  String? repeat;

  TaskModal({
    this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title ?? '',
      'description': description ?? '',
      'isCompleted': isCompleted ?? 0,
      'date': date ?? '',
      'startTime': startTime ?? '',
      'endTime': endTime ?? '',
      'color': color?.value ?? 0xFFFFFFFF,
      'remind': remind ?? 0,
      'repeat': repeat ?? '',
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
      color: Color(map['color'] ?? 0xFFFFFFFF),
      remind: map['remind'],
      repeat: map['repeat'],
    );
  }
}