import 'package:flutter/material.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:flutter_web_ptb/providers/employee_state.dart';
import 'package:flutter_web_ptb/repository/employee_repo.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String role = 'Maker';
String isVendor = 'Internal';

final employeeRoleProvider = StateProvider<String>((ref) => role);
final employeeVendorProvider = StateProvider<String>((ref) => isVendor);

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

  List<Employee>? employees;
  @override
  EmployeeState build() {
    return EmployeeInitial();
  }

  // @override
  // EmployeeState build(int arg) {
  //   return EmployeeInitial();
  // }

  getAllEmployee({Map<String, dynamic>? header}) async {
    state = EmployeeLoading();
    // Map<String, dynamic> header = {};
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      Employee employee =
          Employee.fromMap(JwtDecoder.decode(token)['employee']);
      if (employee.role! != 'SuperAdmin') {
        header!.addAll({'filter': 'role||ne||SuperAdmin'});
      }
      final HttpResponse data =
          await employeeRepo.getAllEmployee('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        employees =
            (data.data as List).map((e) => Employee.fromJson(e)).toList();
        if (employees!.isEmpty) {
          state = EmployeeLoadedEmpty();
        } else {
          state = EmployeeLoaded(employees: employees!);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = EmployeeErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  loginEmployee(String email, String password) async {
    debugPrint('email $email password $password');
    state = EmployeeLoginLoading();
    Map<String, dynamic> login = {'email': email, 'password': password};
    final HttpResponse httpResponse = await employeeRepo.login(login);
    state = EmployeeLoginHTTPResponse(httpResponse: httpResponse);
  }

  createEmployee(Employee employee) async {
    state = EmployeeLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse =
        await employeeRepo.createEmployee(employee, 'Bearer $token');
    debugPrint('${httpResponse.response.statusCode}');
    if (httpResponse.response.statusCode == 201) {
      state = EmployeeDataChangeSuccess();
    }
  }

  deleteEmployee(String nik) async {
    state = EmployeeLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    HttpResponse httpResponse =
        await employeeRepo.deleteEmployee(nik, 'Bearer $token');
    if (httpResponse.response.statusCode == 201 ||
        httpResponse.response.statusCode == 200) {
      state = EmployeeDataChangeSuccess();
    }
  }

  updateEmployeeWithFile({required employee, List<int>? file}) async {
    if (file != null) {
      if (file.isNotEmpty) {
        final sharedPref = await SharedPreferences.getInstance();
        var token = sharedPref.getString(StorageKeys.token) ?? '';
        state = EmployeeLoading();
        final httpResponse = await employeeRepo.updateEmployeeWithFile(
            'Bearer $token',
            employee.nik!,
            employee.name,
            employee.email,
            employee.hp,
            employee.password,
            file);
        debugPrint('${httpResponse.response.statusCode}');
        if (httpResponse.response.statusCode == 200) {
          state = EmployeeDataChangeSuccess();
        }
      }
    } else {
      state = EmployeeLoading();
      final sharedPref = await SharedPreferences.getInstance();
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final httpResponse = await employeeRepo.updateEmployee(
          employee.nik!, employee, 'Bearer $token');
      debugPrint('${httpResponse.response.statusCode}');
      if (httpResponse.response.statusCode == 200) {
        state = EmployeeDataChangeSuccess();
      }
    }
  }

  searchEmployee(String search) async {
    state = EmployeeLoading();
    List<Employee> searchEmployee = employees!
        .where((employee) =>
            employee.name!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    state = EmployeeLoaded(employees: searchEmployee);
  }

  resetDataPassword(String email) async {
    state = EmployeeLoading();
    try {
      var httpResponse = await employeeRepo.resetDataPassword(email);
      debugPrint('${httpResponse.response.statusCode}');
      var response = httpResponse.response;
      debugPrint('response : ${response.data}');
      if (response.statusCode == 202) {
        state = EmployeeResetPassword(message: response.data["message"]);
      }
    } on DioException catch (error) {
      if (error.response!.statusCode == 404) {
        debugPrint(error.response!.data["message"]);
        state = EmployeeErrorServer(
            message: error.response!.data["message"],
            statusCode: error.response!.data["statusCode"]);
      }
    }
  }

  getOneEmployee(String nik) async {
    state = EmployeeLoading();
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';

      final HttpResponse data =
          await employeeRepo.getOneEmployee('Bearer $token', nik);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        Employee employee = Employee.fromJson(data.data);
        state = EmployeeGotOne(employee: employee);
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = EmployeeErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      } else if (error.response!.statusCode == 404) {
        state = EmployeeLoadedEmpty();
      }
    }
  }
}
