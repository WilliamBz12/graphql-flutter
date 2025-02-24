class Task {
  final int? id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
  });

  factory Task.fromMap(Map<String, dynamic> data) {
    return Task(
      id: data['id'],
      title: data['title'],
      category: data['category'],
      description: data['description'],
      isCompleted: data['isCompleted'],
    );
  }
}
