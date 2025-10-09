import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_login_app/modal/data_modal.dart';
import 'package:sqflite_login_app/modal/task_modal.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? database;

   initDB()async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'first.db');
    database = await openDatabase(
        path,
        version: 1,
        onCreate: (db,version){
          String query = "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, password TEXT)";
          db.execute(query);
          String taskQuery = "CREATE TABLE IF NOT EXISTS task(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,description TEXT,  isCompleted INTEGER, date TEXT, startTime TEXT, endTime TEXT, color INTEGER, remind TEXT, repeat TEXT);";
          db.execute(taskQuery);
          print("taskquryy: $taskQuery");

        }
    );
  }

  Future<int?> signUpUser(DataModal dataModal) async {
    if(database != null) {
      String query = "INSERT INTO users(id,name,email,password) VALUES(?,?,?,?);";
      await database!.insert(query, dataModal.toMap());
    } else {
      await initDB();
    }
    return null;
  }

  // Future<bool?> loginUser(DataModal dataModal) async {
  //   if(database != null){
  //     // String query = "SELECT * FROM users WHERE email = ${dataModal.email} 'AND' password = ${dataModal.password}";
  //     // await database!.query(query);
  //     var query = await database!.rawQuery("SELECT * FROM users WHERE email = ? AND ?");
  //     print("query: $query");
  //     if(query.isNotEmpty){
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     await initDB();
  //   }
  //   return null;
  // }

  Future<DataModal?>loginUser(DataModal dataModal) async{

  if(database != null){
  // List args = [dataModal.email, dataModal.password];
  // var result = await database!.rawQuery("select * from users where email '${dataModal.email}' AND '${dataModal.password}'"
  var result = await database!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [dataModal.email, dataModal.password]
  );

    if(result.isNotEmpty){
     return DataModal.fromMap(result.first);
    }
     } else{
      await initDB();
  }
  return null;
  }

  Future<int?> logoutUser() async {
    if(database != null) {
      // String query = "DELETE FROM users WHERE id=?;";
      // await database!.delete('users', where: 'id = ?', whereArgs: [dataModal.id]);
      database!.delete('users');
    } else {
      await initDB();
    }
    return null;
  }

  Future<int?> addTask(TaskModal taskModal) async {
    try {
      if (database == null) {
        await initDB();
      }

      if (database != null) {
        Map<String, dynamic> taskMap = taskModal.toMap();

        int result = await database!.insert('task', taskMap);
        print("Insert result (row ID): $result");

        return result;
      }
    } catch (e) {
      print("Error adding task: $e");
    }
    return null;
  }

  Future<int?> updateData(int taskId, String newTitle, {String? newDescription}) async {
    await database;
    return await database!.update(
      'task',
      {'title': newTitle, 'description': newDescription ?? ''},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<int?> deleteTask(int taskId)async{
    await database;
     return await database!.delete("task", where: 'id = ?', whereArgs: [taskId]);

  }

  //  Future<int?> updateData(String title) async {
  //   if(database != null){
  //     int res = await database!.rawUpdate('UPDATE task SET title = ? WHERE id = ?');
  //     return res;
  //   }else{
  //     await initDB();
  //   }
  //   return null;
  //
  // }
  // Future<List<TaskModal>?> getTasks (String date) async{
  //    if(database != null){
  //      List<Map<String,dynamic>> task = await database!.query("task", where: 'date = ?', whereArgs: [date]);
  //      return List.generate(task.length, (index)=>TaskModal.fromMap(task[index]));
  //    }else{
  //      await initDB();
  //    }
  //    return null;
  // }
  Future<List<TaskModal>?> getTasks (String date) async{

     if(database != null){
       List<Map<String,dynamic>> task = await database!.query("task", where: 'date = ?', whereArgs: [date]);
       // List<Map<String,dynamic>> task = await database!.rawQuery("SELECT * FROM task;");
       return List.generate(task.length, (index)=>TaskModal.fromMap(task[index]));
     }else{
       await initDB();
     }
     return null;
  }

  Future<int> completedTaskStatus(int id) async {
    await database;
    if (database == null) {
      throw Exception('Database not initialized');
    }
    return await database!.rawUpdate('''
    UPDATE task 
    SET isCompleted = ?
    WHERE id = ?
  ''', [1, id]);
  }
}

