import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user.dart';
import './friend_search_card.dart';
import 'package:rxdart/rxdart.dart';



class FriendSearch extends StatefulWidget {

  FriendSearch({@required this.uid});

  final uid;

  @override
  _FriendSearchState createState() => new _FriendSearchState();

}

class _FriendSearchState extends State<FriendSearch>{

  // @override
  // initState(){
  //   searchInputController = new TextEditingController();
  //   super.initState();
  // }

  // TextEditingController searchInputController;

  var searchText = "";

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text("Search New Friend"),
      ),

      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              buildSearchBar(),
              buildFname(),
              buildLname(),
              buildEmail(),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar(){
    return Card(
      shape: inputRadius,
      color: Colors.cyan[600],
      elevation: 6.0,
      child:Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: TextField(
          autofocus: true,
          style: textStyle,
          cursorColor: Colors.white,
          decoration: InputDecoration(labelText: 'Search Friend', labelStyle: textStyle,),
          //controller: searchInputController,
          onSubmitted: (text) {
            setState(() {
              this.searchText = text;
            });
          },
        ),
      ),
    );
  }

  Widget buildFname(){
    var snap = Firestore.instance.collection("users").where('fname', isEqualTo: searchText).snapshots();
    
    return Flexible(
      child: StreamBuilder<QuerySnapshot> (
        stream: snap,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return new Text('Error: ${snapshot.error}');
          }

          switch(snapshot.connectionState){
            //case ConnectionState.none: return Text('Empty');

            case ConnectionState.waiting:
              return new Center(
                child: CircularProgressIndicator(),
              );

            default:
              return new ListView(
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    var friend = User.fromJson(document);
                    return new FriendSearchCard(
                      user: friend,
                      uid: widget.uid,
                    );
                  }
                ).toList(),
              );              
            }
        },
      )
    );
  }

    Widget buildLname(){
      return Flexible(
        child: StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance.collection("users").where('surname', isEqualTo: searchText).snapshots(),
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
                      return new FriendSearchCard(
                        user: friend,
                        uid: widget.uid,
                      );
                    }
                  ).toList(),
                );              
              }
          },
        )
      );
    }
  

  Widget buildEmail(){
      return Flexible(
        child: StreamBuilder<QuerySnapshot> (
          stream: Firestore.instance.collection("users").where('email', isEqualTo: searchText).snapshots(),
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
                      return new FriendSearchCard(
                        user: friend,
                        uid: widget.uid,
                      );
                    }
                  ).toList(),
                );              
              }
          },
        )
      );
    }
  }

  

