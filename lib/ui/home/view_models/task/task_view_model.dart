import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sqlite_offline/domain/use_cases/task/pending_tasks_use_case.dart';

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
    required PendingTasksUseCase pendingTaskUseCase,
  })  : _addTaskUseCase = addTaskUseCase,
        _getTasksUseCase = getTasksUseCase,
        _updateTaskUseCase = updateTaskUseCase,
        _deleteTaskUseCase = deleteTaskUseCase,
        _pendingTasksUseCase = pendingTaskUseCase {
    listenPendingTasks();
  }

  final AddTaskUseCase _addTaskUseCase;
  final GetTasksUseCase _getTasksUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final PendingTasksUseCase _pendingTasksUseCase;

  final perPage = 5;

  PagingState<int, Task> _pagingState = PagingState<int, Task>();
  PagingState<int, Task> get pagingState => _pagingState;

  int _pendingTasks = 0;
  int get pendingTasks => _pendingTasks;

  late Stream<int> _pendingTaskStream;

  void listenPendingTasks() {
    _pendingTaskStream = _pendingTasksUseCase();

    _pendingTaskStream.listen(
      (event) {
        _pendingTasks = event;
        notifyListeners();
      },
    );
  }

  void fetchNewPage() {
    final nextKey = ((_pagingState.keys?.isNotEmpty ?? false)
            ? _pagingState.keys!.last
            : 0) +
        1;
    loadTasks(pageKey: nextKey);
  }

  void refresh() {
    _pagingState = _pagingState.reset();
    notifyListeners();
    loadTasks(pageKey: 1);
  }

  Future<void> loadTasks({
    required int pageKey,
    bool fromNetwork = true,
  }) async {
    final lastState = _pagingState;
    _pagingState = lastState.copyWith(
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
        keys: [
          ...(lastState.keys ?? []),
          pageKey,
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
    refresh();
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
    refresh();
  }

  Future<void> updateTask(
    Task task,
  ) async {
    await _updateTaskUseCase(task);
    refresh();
  }

  Future<void> deleteTask(int id) async {
    await _deleteTaskUseCase(id);
    refresh();
  }
}
