class TaskModel {
  String title;
  bool isCompleted;
  String priority;
  String dueDate;

  TaskModel({
    required this.title,
    this.isCompleted = false,
    this.priority = "Medium",
    this.dueDate = "",
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "isCompleted": isCompleted,
      "priority": priority,
      "dueDate": dueDate,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json["title"],
      isCompleted: json["isCompleted"] ?? false,
      priority: json["priority"] ?? "Medium",
      dueDate: json["dueDate"] ?? "",
    );
  }
}
