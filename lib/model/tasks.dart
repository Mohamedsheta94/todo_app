class Tasks {
  static const String collectionName = "tasks";
  String? title;
  String? description;
  String? id;
  DateTime? dateTime;
  bool? isDone;

  Tasks({
    required this.title,
    required this.dateTime,
    required this.description,
    this.isDone = false,
    this.id = "",
  });

  Tasks.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"],
          description: data["description"],
          title: data["title"],
          dateTime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
          isDone: data["isDone"],
        );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isDone": isDone,
      "dateTime": dateTime?.millisecondsSinceEpoch
    };
  }
}
