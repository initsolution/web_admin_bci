import 'package:flutter_web_ptb/constants/url.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_web_ptb/model/employee.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

part 'employee_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class EmployeeRepo {
  factory EmployeeRepo(Dio dio, {String baseUrl}) = _EmployeeRepo;

  @GET('/employee')
  Future<HttpResponse<dynamic>> getAllEmployee(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @POST('/employee')
  Future<HttpResponse> createEmployee(@Body() Employee employee);

  @PATCH('/employee/{nik}')
  Future<HttpResponse> updateEmployee(
      @Path() String nik, @Body() Employee employee);

  @POST('/employee/login')
  Future<HttpResponse> login(@Body() Map<String, dynamic> login);

  @PATCH('/employee/updateWithFile/{nik}')
  @MultiPart()
  Future<HttpResponse> updateEmployeeWithFile(
    @Path() String nik,
    @Part(name: 'name') String? name,
    @Part(name: 'email') String? email,
    @Part(name: 'hp') String? hp,
    @Part(name: 'password') String? password,
    @Part(contentType: 'image/png', fileName: 'esign', name: 'file')
    List<int> file,
  );
}
