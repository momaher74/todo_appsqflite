import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_appsqflite/cubit/cubit.dart';
import 'package:todo_appsqflite/cubit/states.dart';
import 'package:todo_appsqflite/screens/TasksScreen.dart';
import 'package:todo_appsqflite/screens/archiveScreen.dart';
import 'package:todo_appsqflite/screens/doneScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_appsqflite/shared/constant.dart';

import 'cubit/observar.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  // Use cubits...

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>TodoCubit()..createDataBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var bottomSheetKey = GlobalKey<ScaffoldState>() ;
  var formKey = GlobalKey<FormState>() ;
  int currentIndex = 0;
  int get = 0 ;
  var titleController = TextEditingController() ;
  var dateController = TextEditingController() ;
  var timeController = TextEditingController() ;
  bool isOpened = false  ;

  List<Widget> screens = [TasksScreen(), DoneScreen(), ArchiveScreen()];
  @override
  // void initState() {
  //   super.initState();
  //   TodoCubit.get(context).createDataBase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit , TodoStates>(
      listener: (context , state){
        if(state is AppInsertDataBaseState){
          Navigator.pop(context);
        }
      },
      builder: (context , state){return  Scaffold(
        key:  bottomSheetKey,
        appBar: AppBar(
          title: Text("Todo App "),
        ),
        body: TodoCubit.get(context).newTasks.isEmpty ? Center(child: CircularProgressIndicator()) : screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            //return currentIndex ;
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list_outlined,
                ),
                label: "Tasks"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.done_all,
                ),
                label: "Done"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive,
                ),
                label: "Archive"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: isOpened ?Icon(Icons.add):Icon(
            Icons.edit,
          ),
          onPressed: () {
            // if(isOpened){
            //   Navigator.pop(context);
            //  setState(() {
            //    isOpened=false ;
            //  });
            // }else{
            //   bottomSheetKey.currentState.showBottomSheet((context) => Container(
            //     width:  double.infinity,
            //     height: 400,
            //     color: Colors.blue,
            //     child: Column(
            //       children: [
            //         Row(
            //           children: [
            //             IconButton(icon: Icon(Icons.close , size: 25 , color: Colors.red,) , onPressed: (){
            //               Navigator.pop(context);
            //             })
            //           ],
            //         )
            //       ],
            //     ),
            //   )) ;
            //   setState(() {
            //     isOpened = true ;
            //   });
            // }
            // //insertToDataBase();
            bottomSheetKey.currentState.showBottomSheet((context) => Container(
              width:  double.infinity,
              height: 550,
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(12),
                            width: 45,
                            height: 45,
                            color: Colors.white,
                            child: IconButton(icon: Icon(Icons.close , size: 30 , color: Colors.red, ) , onPressed: (){

                              Navigator.of(context).pop();
                            }),
                          ) ,

                        ],
                      ) ,
                      SizedBox(height: 20,) ,
                      TextFormField(

                        decoration: InputDecoration(

                          icon: Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12) ,
                          ),
                          // suffix: Icon(Icons.title),
                          prefix: Icon(Icons.pending_actions) ,
                          labelText: "Enter Task Name Here " ,
                          //  border: BorderRadius.circular(12),
                        ),
                        controller: titleController,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Data Not Valid " ;
                          }
                          else{
                            return null ;
                          }
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        onTap: (){
                          showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.parse("2025-03-03")).then((value){
                            dateController.text = value.toString() ;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today_sharp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12) ,
                          ),
                          // suffix: Icon(Icons.title),
                          prefix: Icon(Icons.pending_actions) ,
                          labelText: "Enter Task Date " ,
                          //  border: BorderRadius.circular(12),
                        ),
                        controller: dateController,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Data Not Valid " ;
                          }
                          else{
                            return null ;
                          }
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        onTap: (){
                          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                            timeController.text = value.format(context).toString() ;
                          });
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.watch_later),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12) ,
                          ),
                          // suffix: Icon(Icons.title),
                          prefix: Icon(Icons.pending_actions) ,
                          labelText: "Enter Task Time  " ,
                          //  border: BorderRadius.circular(12),
                        ),
                        controller: timeController,
                        validator: (String value){
                          if(value.isEmpty){
                            return "Data Not Valid " ;
                          }
                          else{
                            return null ;
                          }
                        },
                      ),
                      SizedBox(height: 20,) ,
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: ElevatedButton(

                                onPressed: (){
                                  if(formKey.currentState.validate()){
                                    TodoCubit.get(context).insertToDataBase(title: titleController.text, time: timeController.text, date: dateController.text) ;

                                  }
                                }, child: Text("Done") , ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )) ;
          },
        ),
      )  ; },
    );
  }

}
