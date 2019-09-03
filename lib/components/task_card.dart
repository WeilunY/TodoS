import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../style.dart';
import 'package:intl/intl.dart';
import '../views/task_page.dart';

class TaskCard extends StatelessWidget{
  
  TaskCard({@required this.document}); //title, this.duedate, this.type, this.createtime});

  final document;

  Map<int, dynamic> colors = {1: Colors.blue, 2: Colors.purple, 3: Colors.indigo};
  Map<int, dynamic> icons = {1: Icons.home, 2: Icons.school, 3: Icons.work};

  @override
  Widget build(BuildContext context) {

    String id = document.documentID;

    return Dismissible(
      key: Key(id),
      child: buildCard(context),

      onDismissed: (direction) async {
        if(direction == DismissDirection.startToEnd) {
          _handleDelete(id);

           Scaffold.of(context).showSnackBar(
             SnackBar(
               content: Text("${document['title']} Deleted"),
               action: SnackBarAction(
                 label: "Undo",
                 onPressed: () { _handleUndoDelete(document); },
               ),
             )
           );
         
          } else {
            _handleComplete(document);

            Scaffold.of(context).showSnackBar(
             SnackBar(
               content: Text("${document['title']} Completed"),
               action: SnackBarAction(
                 label: "Undo",
                 onPressed: () {_handleUndoComplete(document); },
               ),)
           );  
          }
      },

      background: Container(
        padding: EdgeInsets.only(left: 16.0),
        color: Colors.red[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("DELETE", style: textStyle,)
          ],
        )
      ),

      secondaryBackground: Container(
        padding: EdgeInsets.only(right: 16.0),
        color: Colors.green[800],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("COMPELTE", style: textStyle)
          ],
        )
      ),
    );

  }

  Widget buildCard(BuildContext context){
    return Card(
        color: colors[this.document['type']],
        elevation: 8.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      
        child: Container(
          //decoration: BoxDecoration(),
          child: 
            ListTile(

              onTap: () { 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TaskPage(document: document,)
                ));
                },
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),

              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24)
                  )
                ),

                child: Icon(icons[this.document['type']], color: Colors.white,),
                ),

              title: Text(this.document['title'] ?? "", style: cardTitle,),

              subtitle: Container(
                margin: EdgeInsets.only(top: 8.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 6.0),     
                    child: Text(this.document['due_date'] != null ? "Due ${formatDate(this.document['due_date'])}" : "No due date", 
                          style: cardDue),
                  ),           
                  Text("Created ${formatDate(this.document['create_time'])}", 
                        style: cardCreate),
                ],
               ),
              ),            
            ),   
          )
        );
  }



  String formatDate(Timestamp time) {

    int timestamp = time.toDate().millisecondsSinceEpoch;
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);

    int now = new DateTime.now().millisecondsSinceEpoch;
    int today_0 = now -((now + 28800000) % 86400000);
    int today_24 = today_0 + 86400000;
  
    // just now (2 mins)
    if(timestamp <= now && timestamp > now - 120000 ){
      return "just now";
    }
    // 1 hr ago
    else if (timestamp <= now - 120000 && timestamp > now - 3600000){
      return "a hour ago";
    }
    // earlier today
    else if (timestamp <= now - 3600000 && timestamp >= today_0 ){
      //return new DateFormat("h:mm a").format(date);
      return "today";
    }
    // today
    else if (timestamp > now && timestamp < today_24) {
      return "today";
    }
    else {
      return new DateFormat("yyyy-MM-dd").format(date);
    }

  }

  _handleDelete(String id){
    print("delete");
    Firestore.instance.collection('tasks').document(id).delete();
  }

  _handleUndoDelete(DocumentSnapshot document){
    print("undo delete");
    Firestore.instance.collection('tasks').add(document.data);
  }

  _handleComplete(DocumentSnapshot document) {
    print("compelete");
    Map<String, dynamic> updated_task = {"title": document['title'], "detail": document['detail'], "create_time": document['create_time'],
    "due_date": document['due_date'], "type": document['type'], "status": 1, "finished_time": Timestamp.now()};

    Firestore.instance.collection('tasks').document(document.documentID).updateData(updated_task);
  }

  _handleUndoComplete(DocumentSnapshot document) {

    print("undo complete");

    Map<String, dynamic> updated_task = {"title": document['title'], "detail": document['detail'], "create_time": document['create_time'],
    "due_date": document['due_date'], "type": document['type'], "status": 0};

    Firestore.instance.collection('tasks').document(document.documentID).updateData(updated_task);

  }
}