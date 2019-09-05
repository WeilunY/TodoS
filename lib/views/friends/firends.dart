import 'package:flutter/material.dart';
import 'package:todo_nav/style.dart';

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

    return Scaffold(
      backgroundColor: backColor,

      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Text("${widget.uid}"),
      ),
    );
  }
}