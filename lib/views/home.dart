import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_nav/style.dart';
import '../components/task_card.dart';
import './add_task.dart';
import '../model/task.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    var db = Firestore.instance.collection("users").document(widget.uid).collection('tasks');

    return Scaffold(

      backgroundColor: backColor,
      appBar: AppBar(
        //backgroundColor: Colors.deepPurple[800],
        title: Text(widget.title),
        
        
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot> (

            stream: db.where('status', isEqualTo: 0).orderBy('create_time', descending: true).snapshots(),
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
                        return new TaskCard(
                          document: task, 
                          uid: widget.uid,
                        );
                      }
                    ).toList(),
                  );              
                }
            },
          ),
        ),
      ),

       floatingActionButton: FloatingActionButton(
         elevation: 8.0,
        backgroundColor: Colors.cyan[400],
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTaskPage(uid: widget.uid,))
          );
        },//_showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),

    );
  }

  // text editing
}
