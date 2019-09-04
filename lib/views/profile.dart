import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {

  Profile({@required this.title, this.uid});

  final title;
  final uid;

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
        actions: <Widget>[
          RaisedButton(
            color: Colors.pink,
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "/login"))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),

      body: Center(
        child: Text("${widget.uid}"),
      ),
    );
  }
}