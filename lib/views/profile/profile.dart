import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {

  Profile({@required this.title, this.user});

  final title;
  User user;

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            _buildName(),
            _buildEmail(),
            _buildLogout(),
          ],
        )
      ),
    );
  }

  Widget _buildName(){
    return Card(
      shape: inputRadius,
      color: Colors.cyan[700],
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
              child: Text("${widget.user.fname} ${widget.user.surname}", style: textStyle),
            )
          ],
        ),
      )
    );
  }

  Widget _buildEmail(){
    return Card(
      shape: inputRadius,
      color: Colors.cyan[600],
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
              child: Text("${widget.user.email}", style: textStyle),
            )
          ],
        ),
      )
    );
  }

  Future<Widget> _buildStat() async {

    var snapshots = await Firestore.instance.collection("users")
                .document(widget.user.uid)
                .collection('tasks').getDocuments();

    var total = snapshots.documents.length;

    return Card(
      shape: inputRadius,
      color: Colors.cyan[600],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text("Toatal Tasks: ", style: cardTitle,),
              subtitle: Text("$total", style: textStyle,),
            )
          ],
        ),
      )
    );
  }

  Widget _buildLogout() {
    return RaisedButton(
      
      color: Colors.pink,
      child: Text("Log Out"),
      textColor: Colors.white,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: Text("Are you sure to Log Out?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                FlatButton(
                  child: new Text("Logout"),
                  onPressed: () {
                      FirebaseAuth.instance
                      .signOut()
                      .then((result) =>
                          Navigator.pushReplacementNamed(context, "/login"))
                      .catchError((err) => print(err));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}