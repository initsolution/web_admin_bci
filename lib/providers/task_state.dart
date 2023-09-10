import 'package:equatable/equatable.dart';

import '../model/task.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded({required this.tasks});

  @override
  List<Object?> get props => [tasks];
}

class TaskLoadedEmpty extends TaskState {}

// ignore: must_be_immutable
class TaskErrorServer extends TaskState {
  String? message;
  int? statusCode;
  TaskErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class TaskDataChangeSuccess extends TaskState {}

