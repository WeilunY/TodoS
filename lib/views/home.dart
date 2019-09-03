import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/task_card.dart';
import './add_task.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot> (

            stream: Firestore.instance.collection('tasks').where('status', isEqualTo: 0).orderBy('create_time', descending: true).snapshots(),
            builder: (context, snapshot) {
              
              // error
              if(snapshot.hasError){
                return new Text('Error: ${snapshot.error}');
              }

              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  return new ListView(
                    children: snapshot.data.documents.map(
                      (DocumentSnapshot document) {
                        return new TaskCard(
                          document: document, 
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
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTaskPage())
          );
        },//_showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),

    );
  }

  // text editing
}
