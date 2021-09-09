import 'package:flutter/material.dart';
import 'package:todo_appsqflite/cubit/cubit.dart';

Widget  buildTaskItem({@required model , @required context})=>
    Dismissible(
      key: Key("model['status']"),
      onDismissed: (direction){
        TodoCubit.get(context).deleteData(id: model['id']) ;
      },
      child: Padding(
  padding: EdgeInsets.all(15),
  child: Column(children: [
      Row(children: [
        CircleAvatar(
          backgroundColor:  Colors.red,
          child: Text("${model['time']} "),
          radius: 55,
        ) ,
        SizedBox(width: 20,) ,
        Expanded(
          child: Column(children: [
            Text("${model['title']} " , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold),)  ,
            SizedBox(height: 12,),
            Text(" ${model['date']} ")  ,


          ],),
        ) ,
        Row(
          children: [
            IconButton(icon: Icon(Icons.check_box , color: Colors.green,), onPressed: (){TodoCubit.get(context).
            updateData(status: "done", id:model['id']);}) ,
            IconButton(icon: Icon(Icons.archive , color: Colors.blueGrey,), onPressed: (){
              TodoCubit.get(context).updateData(status: "archive", id:model['id']);
            }) ,
          ],
        )

      ], ) ,
      SizedBox(height: 10,),
      Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Container(
          color: Colors.grey,
          width: double.infinity,
          height: 1,
        ),
      ) ,
  ],),
),
    ) ;