import 'package:flutter/material.dart';

class History extends StatefulWidget {

  History({@required this.title, this.uid});

  final title;
  final uid;

  @override
  _HistoryState createState() => new _HistoryState();
}

class _HistoryState extends State<History> {

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