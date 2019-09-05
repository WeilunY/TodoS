import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_nav/style.dart';
import './camera.dart';

Map<int, String> values = {1: "Home", 2: "School", 3: "Work"};

class AddTaskPage extends StatefulWidget {

  AddTaskPage({@required this.uid});

  final uid;

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {

  @override
  initState() {
    taskTitleInputController = new TextEditingController();
    taskDetailInputController = new TextEditingController();
    super.initState();
  }

  TextEditingController taskTitleInputController;
  TextEditingController taskDetailInputController;


  DateTime dueDate = DateTime.now();
  int _type = 1;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backColor,
      appBar: AppBar(
        title: Text("Create New Task"),
      ),

      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildTitle(),
            buildDetail(),
            buildCamera(),      
            datePicker(),       
            radioPicker(),
            buildButtons(),          
          ],
        ),
      )

    );
  }

  Future<Null> _selectDue(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(new Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null)
      setState(() {
        dueDate = picked;
      });
  }

  Map<int, dynamic> colors = {1: Colors.blue[700], 2: Colors.purple[600], 3: Colors.indigo[600]};

  // Date Picker
  Widget datePicker() {

    return Card(
      shape: inputRadius,
      color: colors[_type],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 10.0, 0, 4.0),
              child:  Text("Set Due: ", style: textStyle,),
            ),
            FlatButton(
              color: colors[_type],
              onPressed: () => _selectDue(context),
              child: Text('${DateFormat("yyyy-MM-dd").format(dueDate)}', style: textStyle,),
            ),    
            
          ]
        )
      )
    );
  }

  // radio picker
  Widget radioPicker() {

    return Card(
      shape: inputRadius,
      color: colors[_type],
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 4.0),
              child:  Text("Select Type: ", style: textStyle,),
            ),   
            buildRadio(1),
            buildRadio(2),
            buildRadio(3),
          ],
        )
      )
    );
  }

  Widget buildRadio(int i){
    return ListTile(
      title: Text('${values[i]}', style: textStyle,),
      leading: Radio(
        activeColor: Colors.white,
        value: i,
        groupValue: _type,
        onChanged: (int value) {
          setState(() {
            _type = value;
          });
        },
      ),
    );
  }

  Widget buildCamera(){
    return Card(
      shape: inputRadius,
      color: colors[_type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: RaisedButton(
          child: Icon(Icons.camera),
          onPressed:() { 
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CameraApp())
            );
          }
        )    
      )
    );
  }
  
  // Text editing


  Widget buildTitle(){
    return Card(
      shape: inputRadius,
      color: colors[_type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: TextField(
          autofocus: true,
          style: textStyle,
          cursorColor: Colors.white,
          decoration: InputDecoration(labelText: 'Task Title*', labelStyle: textStyle,),
          controller: taskTitleInputController,
        ),
      )
    );
  }

  Widget buildDetail() {
    return Card(
      shape: inputRadius,
      color: colors[_type],
      elevation: 6.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: TextField(
          autofocus: true,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          cursorColor: Colors.white,
          style: textStyle,
          decoration: InputDecoration(labelText: 'Task Detail*', labelStyle: textStyle),
          controller: taskDetailInputController,
        ),
      )
    );
  }

  Widget buildButtons() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         RaisedButton(
          child: Text('Cancel', style: textStyle,),
          color: Colors.pink[500],
          onPressed: () {
            taskTitleInputController.clear();
            taskDetailInputController.clear();
            Navigator.pop(context);
          }),

        SizedBox(
          width: 20.0,
        ),

        RaisedButton(
          child: Text('Add', style: textStyle,),
          color: Colors.teal[500],
          onPressed: () {
            if (taskDetailInputController.text.isNotEmpty &&
                taskTitleInputController.text.isNotEmpty) {
              Firestore.instance.collection("users")
                .document(widget.uid)
                .collection('tasks')
                .add({
                  "title": taskTitleInputController.text,
                  "detail": taskDetailInputController.text,
                  "due_date": Timestamp.fromDate(dueDate),
                  "create_time": Timestamp.now(),
                  "status": 0,
                  "type": _type,

              }).catchError((err) => print(err));
              //.then((result) => {
                Navigator.pop(context);
                taskTitleInputController.clear();
                taskDetailInputController.clear();
              //})
             
          }
        })
       ],
    );
  }
  
  

  

}