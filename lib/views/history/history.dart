import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/task.dart';
import './history_card.dart';

class History extends StatefulWidget {

  History({@required this.title, this.uid});

  final title;
  final uid;

  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<History> {

  @override
  Widget build(BuildContext context) {

    var db = Firestore.instance.collection("users").document(widget.uid).collection('tasks');

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot> (

            stream: db.orderBy('create_time', descending: true).snapshots(),
            builder: (context, snapshot) {
              
              // error
              if(snapshot.hasError){
                return new Text('Error: ${snapshot.error}');
              }

              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return new Center(
                    child: Text("Empty"),
                  );

                default:
                  return new ListView(
                    children: snapshot.data.documents.map(
                      (DocumentSnapshot document) {
                        var task = Task.fromJson(document);
                        return new HistoryCard(
                          todo: task, 
                          uid: widget.uid,
                        );
                      }
                    ).toList(),
                  );              
                }
            },
          ),
        )
      ),
    );
  }
}