import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/repository/employee_repo.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

final employeeNotifierProvider =
    NotifierProvider<EmployeeNotifier, EmployeeState>(
  () {
    return EmployeeNotifier(employeeRepo: EmployeeRepo(Dio()));
  },
);

// final employeeNotifierProvider =
//   NotifierFamilyProvider<EmployeeNotifier, EmployeeState, int>((ref, _, id) {

//   },)

// class EmployeeNotifier extends FamilyNotifier <EmployeeState, int> {
class EmployeeNotifier extends Notifier<EmployeeState> {
  final EmployeeRepo employeeRepo;

  EmployeeNotifier({required this.employeeRepo});

  @override
  EmployeeState build() {
    return EmployeeInitial();
  }

  // @override
  // EmployeeState build(int arg) {
  //   return EmployeeInitial();
  // }

  getAllEmployee() async {
    state = EmployeeLoading();
    Map<String, dynamic> header = {};
    final List<Employee> employees = await employeeRepo.getAllEmployee(header);
    if (employees.isEmpty) {
      state = EmployeeLoadedEmpty();
    } else {
      state = EmployeeLoaded(employees: employees);
    }
  }

  loginEmployee(String email, String password) async {
    debugPrint('email $email password $password');
    state = EmployeeLoginLoading();
    Map<String, dynamic> login = {'email': email, 'password': password};
    final HttpResponse httpResponse = await employeeRepo.login(login);
    state = EmployeeLoginHTTPResponse(httpResponse: httpResponse);
  }
}
