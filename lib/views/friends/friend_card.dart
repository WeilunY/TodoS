import 'package:flutter/material.dart';
import '../../style.dart';
import '../../model/user.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';

class FriendCard extends StatelessWidget {

  FriendCard({@required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {

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

              title: Text("${user.fname} ${user.surname}", style: textStyle,),
              
              
            ),
      );
  }
}