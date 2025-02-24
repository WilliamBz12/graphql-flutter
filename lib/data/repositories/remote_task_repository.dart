import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sqlite_offline/data/repositories/task_repository.dart';
import 'package:sqlite_offline/domain/models/task/task.dart';

class RemoteTaskRepository implements TaskRepository {
  final GraphQLClient client;
  RemoteTaskRepository({required this.client});

  @override
  Future<int> addTask(Task task) async {
    const mutationCreateTask = r'''
mutation insertTask($title: String, $category: String, $description: String, $isCompleted: Boolean) {
  insert_tasks_one(object: {category: $category, title: $title, description: $description, isCompleted: $isCompleted}) {
    id
  }
}
''';
    final result = await client.mutate(
      MutationOptions(
        document: gql(mutationCreateTask),
        variables: {
          "title": task.title,
          "category": task.category,
          "description": task.description,
          "isCompleted": task.isCompleted,
        },
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final taskId = result.data?['insert_tasks_one']['id'];
    return taskId ?? 0;
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
      QueryOptions(
        document: gql(queryTasks),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
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
