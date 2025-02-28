import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/models/task/task.dart';
import '../../../../domain/use_cases/task/add_task_use_case.dart';
import '../../../../domain/use_cases/task/delete_task_use_case.dart';
import '../../../../domain/use_cases/task/get_task_use_case.dart';
import '../../../../domain/use_cases/task/update_task_use_case.dart';

class TaskViewModel extends ChangeNotifier {
  TaskViewModel({
    required AddTaskUseCase addTaskUseCase,
    required GetTasksUseCase getTasksUseCase,
    required UpdateTaskUseCase updateTaskUseCase,
    required DeleteTaskUseCase deleteTaskUseCase,
  })  : _addTaskUseCase = addTaskUseCase,
        _getTasksUseCase = getTasksUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase;

  final AddTaskUseCase _addTaskUseCase;
  final GetTasksUseCase _getTasksUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  final perPage = 5;

  List<Task>? _tasks;
  List<Task>? get tasks => _tasks;

  PagingState<int, Task> _pagingState = PagingState<int, Task>();
  PagingState<int, Task> get pagingState => _pagingState;

  Future<void> loadTasks({
    required int pageKey,
    bool fromNetwork = false,
  }) async {
    final lastState = _pagingState;
    _pagingState = PagingState(
      isLoading: true,
      error: null,
    );
    notifyListeners();

    try {
      final tasks = await _getTasksUseCase(
        fromNetwork: fromNetwork,
        perPage: perPage,
        page: pageKey,
      );

      bool isLastPage = tasks.length < perPage;

      _pagingState = PagingState(
        isLoading: false,
        pages: [
          ...(lastState.pages ?? []),
          tasks,
        ],
        error: null,
        hasNextPage: !isLastPage,
      );
      notifyListeners();
    } catch (e) {
      _pagingState = lastState.copyWith(
        isLoading: false,
        error: e,
      );
      notifyListeners();
    }
  }

  Future<void> addTask(
    String title,
    String description,
    String category,
  ) async {
    final task = Task(
      title: title,
      description: description,
      category: category,
      isCompleted: false,
    );
    await _addTaskUseCase(task);
    await loadTasks(fromNetwork: true);
  }

  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      isCompleted: !task.isCompleted,
    );
    await _updateTaskUseCase(updatedTask);
    await loadTasks(fromNetwork: true);
  }

  Future<void> updateTask(
    Task task,
  ) async {
    await _updateTaskUseCase(task);
    await loadTasks(fromNetwork: true);
  }

  Future<void> deleteTask(int id) async {
    await _deleteTaskUseCase(id);
    await loadTasks(fromNetwork: true);
  }
}
