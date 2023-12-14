import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'task_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class TaskRepo {
  factory TaskRepo(Dio dio, {String baseUrl}) = _TaskRepo;

  @GET('/task')
  Future<HttpResponse<dynamic>> getAllTask(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @GET('/task/customGetAll')
  Future<HttpResponse<dynamic>> getCustomAllTask(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @POST('/task')
  Future<HttpResponse> createTask(
      @Body() Task task, @Header('Authorization') String token);

  @PATCH('/task/{id}')
  Future<HttpResponse> updateTask(
      @Header('Authorization') String token, @Path() int id, @Body() Task task);

  @DELETE('/task/{id}')
  Future<HttpResponse> deleteTask(
      @Header('Authorization') String token, @Path() int id);
}
