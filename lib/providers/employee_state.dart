// ignore_for_file: must_be_immutable

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
class EmployeeErrorServer extends EmployeeState {
  String? message;
  int? statusCode;
  EmployeeErrorServer({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class EmployeeLoginSuccess extends EmployeeState {}

class EmployeeLoginLoading extends EmployeeState {}

class EmployeeDataChangeSuccess extends EmployeeState {}

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

class EmployeeResetPassword extends EmployeeState {
  String? message;
  EmployeeResetPassword({required this.message});

  @override
  List<Object?> get props => [message];
}

class EmployeeGotOne extends EmployeeState {
  Employee employee;
  EmployeeGotOne({required this.employee});

  @override
  List<Object?> get props => [employee];
}
