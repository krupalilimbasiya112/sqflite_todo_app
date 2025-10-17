import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sqflite_login_app/modal/task_modal.dart';

class TodoService {

  TodoService._();

  static final TodoService todoService = TodoService._();

  final String boxName = 'todoBox';

  Future<Box<TaskModal>> get _box async => await Hive.openBox<TaskModal>(boxName);

  addTask (TaskModal taskModal) async {
    var box = await _box;
    var rowId = await box.add(taskModal);
    print('Final result (row iddddddddddddd): $rowId');
  }

  Future<List<TaskModal>> getAllTask () async{
    var box = await _box;
   return await box.values.toList();
  }

  Future<void> deleteTask(int index) async{
    var box = await _box;
    box.deleteAt(index);
  }

  Future<void> updateTakStatus(TaskModal taskModal, int index) async{
    var box = await _box;
    box.putAt(index, taskModal);

  }

}