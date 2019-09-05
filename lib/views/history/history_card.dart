import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../style.dart';
import 'package:intl/intl.dart';
import '../../model/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './history_page.dart';

class HistoryCard extends StatelessWidget {

  HistoryCard({@required this.todo, this.uid});

  Task todo;
  final uid;

  @override
  Widget build(BuildContext context){

  var icon = todo.status == 1 ? Icons.check_circle: Icons.cached;
  var created_time = "Created on " + DateFormat("yyyy-MM-dd").format(todo.createTime.toDate());
  var finished_time = todo.finishedTime != null ? "Completed on " + DateFormat("yyyy-MM-dd").format(todo.createTime.toDate()) : "In Progress";

    return Slidable(
      
      key: Key(todo.id.toString()),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,

      actions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          _handleDelete(todo.id);
          Scaffold.of(context).showSnackBar(
             SnackBar(
               content: Text("${todo.title} Deleted"),
               action: SnackBarAction(
                 label: "Undo",
                 onPressed: () {_handleUndoDelete(todo); },
               ),
             )
           );
          },
        ),
      ],
      
      secondaryActions: <Widget>[
        IconSlideAction(
        caption: todo.status == 1 ? "INCOMPLETE" : "COMPLETE",
        color: todo.status == 1 ? incomplete : complete,
        icon: todo.status == 1 ? Icons.cancel : Icons.check_circle,
        onTap: () {

          if (todo.status == 1) {
            _handleINComplete(todo);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("${todo.title} marked as incomplete"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {_handleUndoINComplete(todo); },
                ),
              )
            );
          } else {
            _handleComplete(todo);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("${todo.title} marked as complete"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {_handleUndoComplete(todo); },
                ),
              )
            );
          }
          
          },
        ),
      ],


      child: 
        Card(
          elevation: 8.0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          color: todo.status == 1 ? complete : incomplete,
          child: 
            ListTile(
              onTap: () { 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HistoryPage(document: todo,)
                ));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0,color: Colors.white,))
                        ),
                child: Icon(icon, color: Colors.white,),
                ),

              title: Text(todo.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white,),),
              
              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6.0),     
                    child: Text(created_time, 
                          style: TextStyle(color: Colors.grey[200], fontSize: 14.0),),
                  ),           
                  Text(finished_time, 
                        style: TextStyle(color: Colors.grey[200], fontSize: 14.0),),

                  ],
                ),
              ),
            ),
      ),

    );
  
  }

  _handleDelete(String id){
    print("delete");
    Firestore.instance.collection("users").document(uid).collection('tasks').document(id).delete();
  }

  _handleUndoDelete(Task document){
    print("undo delete");
    Firestore.instance.collection("users").document(uid).collection('tasks').add(document.toJson());
  }

  _handleComplete(Task document) {
    print("compelete");
    document.status = 1;
    document.finishedTime = Timestamp.now();

    Firestore.instance.collection("users").document(uid).collection('tasks').document(document.id).updateData(document.toJson());
  }

  _handleUndoComplete(Task document) {

    print("undo complete");

    document.status = 0;
    document.finishedTime = null;

    Firestore.instance.collection("users").document(uid).collection('tasks').document(document.id).updateData(document.toJson());

  }

  var temp;

  _handleINComplete(Task document) {
    print("incompelete");
    document.status = 0;
    temp = todo.finishedTime;
    document.finishedTime = null;

    Firestore.instance.collection("users").document(uid).collection('tasks').document(document.id).updateData(document.toJson());
  }

  _handleUndoINComplete(Task document) {

    print("undo incomplete");

    document.status = 1;
    document.finishedTime = temp;

    Firestore.instance.collection("users").document(uid).collection('tasks').document(document.id).updateData(document.toJson());

  }

}

