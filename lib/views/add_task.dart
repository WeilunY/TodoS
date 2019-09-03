import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<int, String> values = {1: "Home", 2: "Work", 3: "School"};

class AddTaskPage extends StatefulWidget {

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
            SizedBox(height: 20.0,),
            datePicker(),
            SizedBox(height: 10.0,),
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

  // Date Picker
  Widget datePicker() {
    return Row(
      children: <Widget>[

        RaisedButton(
          onPressed: () => _selectDue(context),
          child: Text('Select date'),
        ),    
        SizedBox(width: 20.0,),
        Text(DateFormat("yyyy-MM-dd").format(dueDate)),
        
      ]
    );
  }

  // radio picker
  Widget radioPicker() {
    return Column(
      children: <Widget>[
        buildRadio(1),
        buildRadio(2),
        buildRadio(3),
      ],
    );
  }

  Widget buildRadio(int i){
    return ListTile(
      title: Text('${values[i]}'),
      leading: Radio(
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
  
  // Text editing


  Widget buildTitle(){
    return Container(
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(labelText: 'Task Title*'),
        controller: taskTitleInputController,
      ),
    );
  }

  Widget buildDetail() {
    return Container(
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(labelText: 'Task Detail*'),
        controller: taskDetailInputController,
      ),
    );
  }

  Widget buildButtons() {

    return Row(
       children: <Widget>[
         RaisedButton(
          child: Text('Cancel'),
          onPressed: () {
            taskTitleInputController.clear();
            taskDetailInputController.clear();
            Navigator.pop(context);
          }),

        RaisedButton(
          child: Text('Add'),
          onPressed: () {
            if (taskDetailInputController.text.isNotEmpty &&
                taskTitleInputController.text.isNotEmpty) {
              Firestore.instance
                .collection('tasks')
                .add({
                  "title": taskTitleInputController.text,
                  "detail": taskDetailInputController.text,
                  "due_date": Timestamp.fromDate(dueDate),
                  "create_time": Timestamp.now(),
                  "status": 0,
                  "type": _type,

              })
              .then((result) => {
                Navigator.pop(context),
                taskTitleInputController.clear(),
                taskDetailInputController.clear(),
              })
              .catchError((err) => print(err));
          }
        })
       ],
    );
  }
  
  

  

}