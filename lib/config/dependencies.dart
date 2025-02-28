import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqlite_offline/config/api_client.dart';
import 'package:sqlite_offline/data/repositories/remote_task_repository.dart';
import 'package:sqlite_offline/data/repositories/task_repository.dart';
import 'package:sqlite_offline/domain/use_cases/task/add_task_use_case.dart';
import 'package:sqlite_offline/domain/use_cases/task/delete_task_use_case.dart';
import 'package:sqlite_offline/domain/use_cases/task/get_task_use_case.dart';
import 'package:sqlite_offline/domain/use_cases/task/pending_tasks_use_case.dart';
import 'package:sqlite_offline/domain/use_cases/task/update_task_use_case.dart';
import 'package:sqlite_offline/ui/home/view_models/task/task_view_model.dart';

List<SingleChildWidget> get providersLocal {
  return [
    Provider<GraphQLClient>(
      create: (context) => ApiClient.create(),
    ),
    Provider<TaskRepository>(
      create: (context) => RemoteTaskRepository(
        client: context.read<GraphQLClient>(),
      ),
    ),
    Provider<AddTaskUseCase>(
      lazy: true,
      create: (context) => AddTaskUseCase(context.read()),
    ),
    Provider<UpdateTaskUseCase>(
      lazy: true,
      create: (context) => UpdateTaskUseCase(context.read()),
    ),
    Provider<DeleteTaskUseCase>(
      lazy: true,
      create: (context) => DeleteTaskUseCase(context.read()),
    ),
    Provider<GetTasksUseCase>(
      lazy: true,
      create: (context) => GetTasksUseCase(context.read()),
    ),
    Provider<PendingTasksUseCase>(
      lazy: true,
      create: (context) => PendingTasksUseCase(context.read()),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => TaskViewModel(
        addTaskUseCase: context.read(),
        getTasksUseCase: context.read(),
        updateTaskUseCase: context.read(),
        deleteTaskUseCase: context.read(),
        pendingTaskUseCase: context.read(),
      ),
    )
  ];
}
