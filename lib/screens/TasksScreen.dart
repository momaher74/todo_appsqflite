import 'package:flutter/material.dart';
import 'package:todo_appsqflite/cubit/cubit.dart';
import 'package:todo_appsqflite/shared/component.dart';
import 'package:todo_appsqflite/shared/constant.dart';
class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List tasks = TodoCubit.get(context).newTasks ;
    return Container(
      child: ListView.builder(itemBuilder: (context , index)=>buildTaskItem( model : tasks[index] , context:context) , itemCount: tasks.length,),
    );
  }
}
