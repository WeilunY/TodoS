import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        child: Text("${widget.uid}"),
      ),
    );
  }
}