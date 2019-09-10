import 'package:flutter/material.dart';
import '../../style.dart';
import '../../model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './friend_search.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';

class FriendSearchCard extends StatefulWidget {

  FriendSearchCard({@required this.user, this.uid});

  final User user;
  final uid;

  @override
  _FriendSearchCardState createState() => new _FriendSearchCardState();
}

class _FriendSearchCardState extends State<FriendSearchCard>{

  bool friend = false;

  // @override
  // void initState() async {
  //   var snapShot = await Firestore.instance.collection("users").document(widget.uid).collection('friends').document(widget.user.uid).get();

  //   if (snapShot != null || snapShot.exists) {
  //     setState(() {
  //       friend = true;
  //     });
  //   }

    
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
     

    if(widget.user.uid == widget.uid){
      return Container();
    }

    return FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("users").document(widget.uid).collection('friends').document(widget.user.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.data == null || !snapshot.data.exists){
            return buildStranger();
          }
          else {
            return buildFriend();
          }
      }
    );
  }


  Widget buildStranger(){
    return Card(
        elevation: 8.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        color: Colors.cyan,
        child: 
          ListTile(

            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0,color: Colors.white,))
                      ),
              child: Icon(Icons.person, color: Colors.white,),
              ),

            title: Text("${widget.user.fname} ${widget.user.surname}", style: textStyle,),
            subtitle: Text("${widget.user.email}", style: cardDue,),
            trailing: FlatButton(
              child: Icon(Icons.add),
            ),
        ),
    );
  }

  Widget buildFriend(){
    return Card(
      elevation: 8.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.cyan[800],
      child: 
        ListTile(

          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0,color: Colors.white,))
                    ),
            child: Icon(Icons.person, color: Colors.white,),
            ),

          title: Text("${widget.user.fname} ${widget.user.surname}", style: textStyle,),
          subtitle: Text("${widget.user.email}", style: cardDue,),
          
      ),
    );
  }

  void addFriend() async {
    var user_db = Firestore.instance.collection('users').document(widget.uid).collection('friends');
    var friend_db = Firestore.instance.collection('users').document(widget.user.uid).collection('friends');

    // set user
    await user_db.document(widget.user.uid).setData({
      "fname": widget.user.fname,
      "surname": widget.user.surname,
    });

    // set friend

    await user_db.document(widget.user.uid).setData({
      "fname": widget.user.fname,
      "surname": widget.user.surname,
    });
  }
}