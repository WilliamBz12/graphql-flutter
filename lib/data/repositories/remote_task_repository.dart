import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sqlite_offline/data/repositories/task_repository.dart';
import 'package:sqlite_offline/domain/models/task/task.dart';

class RemoteTaskRepository implements TaskRepository {
  final GraphQLClient client;
  RemoteTaskRepository({required this.client});

  @override
  Future<int> addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTask(int id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> getTasks() async {
    const queryTasks = '''
query {
  tasks {
    id
    title
    isCompleted
    description
    category
  }
}
''';

    final result = await client.query(
      QueryOptions(document: gql(queryTasks)),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final data = result.data?['tasks'] as List?;
    final tasks = data?.map((e) => Task.fromMap(e)).toList();
    return tasks ?? [];
  }

  @override
  Future<bool> updateTask(Task task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
