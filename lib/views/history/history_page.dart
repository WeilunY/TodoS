import 'dart:convert';
import 'package:todo_nav/style.dart';
import 'package:flutter/material.dart';
import 'package:todo_nav/model/task.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {

  HistoryPage({@required this.document});

  Task document;

  Map<int, dynamic> colors = {1: Colors.blue[700], 2: Colors.purple[600], 3: Colors.indigo[600]};
  Map<int, String> status = {0: "In Progress", 1: "Completed"};
  Map<int, String> type = {1: "Home", 2: "School", 3: "Work"};

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text("${status[this.document.status]}"),
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            buildTitle(),
            buildDetail(),
            buildPhoto(),
            buildType(),
            buildDue(),
            buildCreate(),
            buildFinished(),
          ],
        ),
      ),
    ); 
  }

   

  Widget buildTitle(){
    return Card(
      shape: inputRadius,
      color: colors[this.document.type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Text("Title: ", style: cardTitle,),

            Container(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child:  Text(this.document.title, style: textStyle,),
            ),
          ]
        ),
      )
    );
  }

  Widget buildDetail(){
    return Card(
      shape: inputRadius,
      color: colors[this.document.type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Detail: ", style: cardTitle,),

            Container(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
              child:  Text(this.document.detail, style: textStyle,),
            ),
          ]
        ),
      )
    );
  }

  Widget buildPhoto(){
    if(this.document.image == null){
      return Container();
    }

    List<int> bytes = base64Decode(this.document.image);
    return Card(
      shape: inputRadius,
      color: colors[this.document.type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Photo: ", style: cardTitle,),
            SizedBox(height: 10.0,),
            Image.memory(bytes),
            ]
          )
        ),
      );
    }

    Widget buildType(){
      return Card(
        shape: inputRadius,
        color: colors[this.document.type],
        elevation: 6.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Type: ", style: cardTitle,),

              Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child:  Text(type[this.document.type], style: textStyle,),
              ),
            ]
          ),
        )
      );
    }

    Widget buildDue(){
      return Card(
        shape: inputRadius,
        color: colors[this.document.type],
        elevation: 6.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Due Date: ", style: cardTitle,),

              Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child:  Text(DateFormat("yyyy-MM-dd").format(document.dueDate.toDate()), style: textStyle,),
              ),
            ]
          ),
        )
      );
    }

    Widget buildCreate(){
      return Card(
        shape: inputRadius,
        color: colors[this.document.type],
        elevation: 6.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Create Date: ", style: cardTitle,),

              Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child:  Text(DateFormat("yyyy-MM-dd").format(document.createTime.toDate()), style: textStyle,),
              ),
            ]
          ),
        )
      );
    }

    Widget buildFinished(){
      if(document.status == 0){
        return Container();
      }
      return Card(
        shape: inputRadius,
        color: colors[this.document.type],
        elevation: 6.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Finished Date: ", style: cardTitle,),

              Container(
                padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                child:  Text(DateFormat("yyyy-MM-dd").format(document.finishedTime.toDate()), style: textStyle,),
              ),
            ]
          ),
        )
      );
    }

    
  }
