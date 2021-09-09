import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_appsqflite/cubit/states.dart';
import 'package:todo_appsqflite/shared/constant.dart';

class TodoCubit extends Cubit<TodoStates> {
  
  TodoCubit() : super(InitialState());

  static TodoCubit get(context) => BlocProvider.of(context);
  Database database;
  List newTasks = [ ];
  List doneTasks = [];
  List archiveTasks = [];

  createDataBase()async  {
     await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print("creating database");
        database
            .execute(
                'create table tasks (id integer primary key , title text , date text , time text , status text )')
            .then((value) {
          print("creating database finished");
        }).catchError((error) {
          print("its error ${error.toString()} ");
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
        print("opening database");
      },
    ).then((value) {
      database = value ;
      emit(AppCreateDataBaseState()) ;
     });
  }

  Future insertToDataBase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              "INSERT INTO tasks(title, date, time, status) VALUES( '$title' , '$date' , '$time' , 'new' )")
          .then((value) {
            print("insert Done");
            emit(AppInsertDataBaseState()) ;
             getDataFromDataBase(database);
        // getDataFromDataBase(database).then((value) {
        //   tasks = value;
        //   // tasks.forEach((element) {
        //   //   // if (element['status'] == "done") {
        //   //   //   doneList.add(element);
        //   //   //   print(doneList);
        //   //   // } else if (element['status'] == "archive") {
        //   //   //   archiveList.add(element);
        //   //   // }
        //   // });
        //
        //   print(tasks);
        // });

      }).catchError((error) {
        print("insert error $error");
      });
    });
  }

   getDataFromDataBase(database) async {
    newTasks= [] ;
    doneTasks=[];
    archiveTasks = [] ;
    emit(AppGetDataBaseLoadingState()) ;
     database.rawQuery('SELECT * FROM tasks').
     then((value) {
       value.forEach((element) {

         if(element['status']=='new'){
           newTasks.add(element) ;
         }
         else if(element['status']=='done'){
           doneTasks.add(element) ;
         }
         else {
           archiveTasks.add(element) ;
         }
         emit(AppGetDataBaseState()) ;
       })  ;
     });
  }
  void updateData({@required String status, @required int id,}) {
    
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDataBase(database) ;
      emit(AppUpdateDataBaseState()) ;
    });
    // print('updated: $count');
  }
  void deleteData({ @required int id,}) {

    database.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database) ;
      emit(AppDeleteDataBaseState()) ;
    });
    // print('updated: $count');
  }
}
