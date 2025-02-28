import 'package:flutter/foundation.dart';

import '../../../data/repositories/task_repository.dart';

class PendingTasksUseCase {
  PendingTasksUseCase(this._repository);

  final TaskRepository _repository;

  Stream<int> call() {
    try {
      return _repository.subscriptionPendingTasks();
    } catch (e) {
      debugPrint('Erro ao buscar tarefas: $e');
      rethrow;
    }
  }
}
