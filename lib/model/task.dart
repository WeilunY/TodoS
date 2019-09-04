
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
    String id;
    String title;
    String detail;
    Timestamp createTime;
    Timestamp dueDate;
    Timestamp finishedTime;
    int type;
    int status;
    

    Task({
        this.title,
        this.detail,
        this.createTime,
        this.dueDate,
        this.type,
        this.status,
        this.finishedTime,
        this.id,
    });

    factory Task.fromJson(DocumentSnapshot json) => new Task(
        title: json["title"],
        detail: json["detail"],
        createTime: json["create_time"],
        dueDate: json["due_date"],
        type: json["type"],
        status: json["status"],
        finishedTime: json["finished_time"],
        id: json.documentID,
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "detail": detail,
        "create_time": createTime,
        "due_date": dueDate,
        "type": type,
        "status": status,
        "finished_time": finishedTime,
    };
}
