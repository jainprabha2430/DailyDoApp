class TaskModel {
  String title;
  String? description;
  bool isCompleted;

  TaskModel({
    required this.title,
    this.description,
    this.isCompleted = false,
  });
}
