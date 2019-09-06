import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user.dart';
import './friend_card.dart';
import './friend_search.dart';

class Friends extends StatefulWidget {

  Friends({@required this.title, this.uid});

  final title;
  final uid;

  @override
  _FriendsState createState() => new _FriendsState();
}

class _FriendsState extends State<Friends> {


  @override
  Widget build(BuildContext context) {

    var db = Firestore.instance.collection("users").document(widget.uid).collection('friends');

    return Scaffold(
      backgroundColor: backColor,

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot> (
            stream: db.orderBy('fname').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return new Text('Error: ${snapshot.error}');
              }

              switch(snapshot.connectionState){
                case ConnectionState.none: return Text('Empty');

                case ConnectionState.waiting:
                  return new Center(
                    child: CircularProgressIndicator(),
                  );

                default:
                  return new ListView(
                    children: snapshot.data.documents.map(
                      (DocumentSnapshot document) {
                        var friend = User.fromJson(document);
                        return new FriendCard(
                          user: friend,
                        );
                      }
                    ).toList(),
                  );              
                }
            },
          )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => FriendSearch(uid: widget.uid,)
          ));
        },
      ),
    );
  }
}