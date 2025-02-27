import 'package:sqlite_offline/domain/models/task/task.dart';

abstract class TaskRepository {
  Future<int> addTask(Task task);
  Future<List<Task>> getTasks({
    required bool fromNetwork,
    required int page,
    required int perPage,
  });
  Future<bool> updateTask(Task task);
  Future<bool> deleteTask(int id);
}
