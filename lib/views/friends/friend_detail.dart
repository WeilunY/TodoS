import 'package:flutter/material.dart';
import '../../model/user.dart';
import 'package:todo_nav/style.dart';

class FriendDetails extends StatelessWidget{

  FriendDetails({@required this.user, this.friend});

  final User user;
  final bool friend;

  @override
  Widget build(BuildContext context){
    

    return Scaffold(
      appBar: AppBar(
        title: Text("${user.fname} ${user.surname}"),
      ),
      backgroundColor: backColor,
      body:Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            friend == true ? buildFriend() : buildStranger(),
            _buildName(),
            _buildEmail(),
            
          ],
        )
      ),
    );
      
  }

  Widget buildFriend() {
    return Card(
      shape: inputRadius,
      color: friend == true ? friendColor : strangerColor,
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: 
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text("You and ${user.fname} are friend", style: cardTitle),
        ),
            
      ),
    );
  }

  Widget buildStranger(){
    return Card(
      shape: inputRadius,
      color: friend == true ? friendColor : strangerColor,
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Your and ${user.fname} are not friend", style: cardTitle),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: RaisedButton(
                child: Text("Add as Friend", style: textStyle,),
                color: Colors.green,
                onPressed: (){},
              )
               
            )
          ],
        ),
      )
    );
  }

  Widget _buildName(){
    return Card(
      shape: inputRadius,
      color: friend == true ? friendColor : strangerColor,
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Name: ", style: cardTitle),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Text("${this.user.fname} ${this.user.surname}", style: textStyle),
            )
          ],
        ),
      )
    );
  }

  Widget _buildEmail(){
    return Card(
      shape: inputRadius,
      color: friend == true ? friendColor : strangerColor,
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Email: ", style: cardTitle),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Text("${this.user.email}", style: textStyle),
            )
          ],
        ),
      )
    );
  }
}