abstract class TodoStates {}

class InitialState extends TodoStates {}

class TodoLoadingState extends InitialState {}

class CreateDataBaseState extends InitialState {}

class GetDataBaseState extends InitialState {}

class InsertDataBaseState extends InitialState {}

class UpdateDataBaseState extends InitialState {}

class AppGetDataBaseState extends InitialState {}

class AppChangBottomSheetState extends InitialState {}

class AppGetDataBaseLoadingState extends InitialState {}

class AppDeleteDataBaseState extends InitialState {}

class AppUpdateDataBaseState extends InitialState {}

class AppInsertDataBaseState extends InitialState {}

class AppCreateDataBaseState extends InitialState {}

class AppChangeNavBarBottom extends InitialState {}
