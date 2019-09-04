import 'package:flutter/material.dart';
import 'package:todo_nav/model/user.dart';
import 'package:todo_nav/model/task.dart';
import 'package:todo_nav/views/home.dart';
import 'history.dart';
import 'profile.dart';
import 'firends.dart';

class Navigation extends StatefulWidget{

  Navigation({@required this.user});
  User user;

  @override
  _NavigationState createState() => new _NavigationState();
}

class _NavigationState extends State<Navigation> with SingleTickerProviderStateMixin{

  TabController controller;

  @override
  void initState() {
    controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context){
    return Scaffold(
       body: TabBarView(
        controller: controller,
        children: <Widget>[
          MyHomePage(title: "${widget.user.fname}'s Task", uid: widget.user.uid,),
          History(title: "${widget.user.fname}'s History", uid: widget.user.uid,),
          Friends(title: "${widget.user.fname}'s Friends", uid: widget.user.uid,),
          Profile(title: "${widget.user.fname}'s Profile", uid: widget.user.uid,),
        ],
      ),

      // navigation bar
      bottomNavigationBar: new Material(
        color: Color.fromRGBO(44, 50, 65, 1.0),
        child: TabBar(
          controller: controller,
          tabs: <Tab>[
            Tab(text: "To-Dos", icon: new Icon(Icons.list)),
            Tab(text: "History", icon: new Icon(Icons.history)),
            Tab(text: "Friends", icon: new Icon(Icons.people)),
            Tab(text: "Profile", icon: new Icon(Icons.person))
          ],
        ),
      ),
    );
  }

}