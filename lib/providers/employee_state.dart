import 'package:equatable/equatable.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:retrofit/retrofit.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  EmployeeLoaded({required this.employees});

  @override
  List<Object?> get props => [employees];
}

class EmployeeLoadedEmpty extends EmployeeState {}

// ignore: must_be_immutable
class EmployeeError extends EmployeeState {
  String? message;
  EmployeeError({this.message});

  @override
  List<Object?> get props => [message];
}

class EmployeeLoginSuccess extends EmployeeState {}

class EmployeeLoginLoading extends EmployeeState {}

// ignore: must_be_immutable
class EmployeeLoginFailed extends EmployeeState {
  String? message;
  EmployeeLoginFailed({this.message});
  @override
  List<Object?> get props => [message];
}

class EmployeeLoginHTTPResponse extends EmployeeState {
  final HttpResponse httpResponse;
  EmployeeLoginHTTPResponse({required this.httpResponse});

  @override
  List<Object?> get props => [httpResponse];
}
