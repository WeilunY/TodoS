import 'package:flutter/material.dart';
import 'package:todo_nav/model/task.dart';

class TaskPage extends StatelessWidget {

  TaskPage({@required this.document});

  Task document;

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("${this.document.title}"),
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            buildDetail(),
          ],
        ),
      ),
    ); 
  }

  Widget buildDetail(){
    return Container(
      child: Column(
        children: <Widget>[
          Text("Details:"),

          Text("${this.document.detail}")
        ],
      ),
    );
  }
}