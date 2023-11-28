import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/mastercategorychecklistpreventive.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'mastercategorychecklistpreventive_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class MasterCategoryChecklistPreventiveRepo {
  factory MasterCategoryChecklistPreventiveRepo(Dio dio, {String baseUrl}) =
      _MasterCategoryChecklistPreventiveRepo;

  @GET('/mastercategorychecklistpreventive')
  Future<HttpResponse<dynamic>> getAllMasterCategoryChecklistPreventive(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @POST('/mastercategorychecklistpreventive')
  Future<HttpResponse> createMasterCategoryChecklistPreventive(
      @Body() MasterCategoryChecklistPreventive masterCategoryPrev,
      @Header('Authorization') String token);

  @PATCH('/mastercategorychecklistpreventive/{id}')
  Future<HttpResponse> updateMasterCategoryChecklistPreventive(
      @Path() int id,
      @Body() MasterCategoryChecklistPreventive masterCategoryPrev,
      @Header('Authorization') String token);

  @DELETE('/mastercategorychecklistpreventive/{id}')
  Future<HttpResponse> deleteMasterCategoryChecklistPreventive(
      @Path() int id, @Header('Authorization') String token);
}
