// ignore_for_file: file_names, prefer_const_constructors
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/Database/database.dart';
import 'package:todo/utility/dialogbox.dart';
import 'package:todo/utility/todo-tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //hive box reference
  final _myBoxInstance = Hive.openBox('myBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this is the 1st
    //time ever opening the app, then create default data
    if (_myBoxInstance == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  //checkbox taped change
  void checkBoxChange(bool? value, int index) {
    setState(() {
      db.tiDoList[index][1] = !db.tiDoList[index][1];
    });
    db.updateDataBase();
  }

  //save box
  void saveTask() {
    setState(() {
      db.tiDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // creating new task
  void createNewTask() {
    showDialog(
        context: context,
        builder: (contex) {
          return DialogBox(
            controller: _controller,
            onSave: saveTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  //delete task
  void deleteTask(int index) {
    setState(() {
      db.tiDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "To Do List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        
      ),
      body: ListView.builder(
        itemCount: db.tiDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.tiDoList[index][0],
            taskCompleted: db.tiDoList[index][1],
            onChanged: ((value) => checkBoxChange(value, index)),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
