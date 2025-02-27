import 'package:flutter/foundation.dart';

import '../../../data/repositories/task_repository.dart';
import '../../models/task/task.dart';

/// Use Case para obter todas as tarefas
class GetTasksUseCase {
  GetTasksUseCase(this._repository);

  final TaskRepository _repository;

  Future<List<Task>> call({
    required bool fromNetwork,
    required int page,
    required int perPage,
  }) async {
    try {
      return await _repository.getTasks(
        fromNetwork: fromNetwork,
        page: page,
        perPage: perPage,
      );
    } catch (e) {
      debugPrint('Erro ao buscar tarefas: $e');
      rethrow;
    }
  }
}
