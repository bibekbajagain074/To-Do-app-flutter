// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

class ToDoDatabase {
  List tiDoList = [];

  //refrense box
  final _myBox = Hive.box('MyBox');

  //metod for first openingg app

  void createInitialData() {
    tiDoList = [
      ["i hhabe", false],
      ["i hhabe", false],
    ];
  }

  // load data frim database
  void loadData() {
    tiDoList = _myBox.get('ToDoList');
  }

  //update database
  void updateDataBase() {
    _myBox.put("ToDoList", tiDoList);
  }
}
