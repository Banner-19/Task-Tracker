

class Task{
  String content;
  DateTime samay;
  bool done;
  // Constructor
  Task({required this.content,required this.samay,required this.done});

  factory Task.fromMap(Map task){
    return Task(content: task["content"],
      samay: task["time"],
      done: task["isDone"],
    );
  }

  Map tomap(){
    return {
      "content":content,
      "time":samay,
      "isDone":done,
    };
  }
}