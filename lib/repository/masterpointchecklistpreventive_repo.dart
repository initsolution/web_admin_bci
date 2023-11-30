import 'package:flutter_web_ptb/model/masterpointchecklistpreventive.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_web_ptb/constants/url.dart';

part 'masterpointchecklistpreventive_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class MasterPointChecklistPreventiveRepo {
  static const String urlLocal = '/masterpointchecklistpreventive';
  factory MasterPointChecklistPreventiveRepo(Dio dio, {String baseUrl}) =
      _MasterPointChecklistPreventiveRepo;

  @GET(urlLocal)
  Future<HttpResponse<dynamic>> getAllMasterPointChecklistPreventive(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic> queries);

  @POST(urlLocal)
  Future<HttpResponse> createMasterPointChecklistPreventive(
      @Body() MasterPointChecklistPreventive masterPointChecklistPreventive,
      @Header('Authorization') String token);

  @PATCH('$urlLocal/{id}')
  Future<HttpResponse> updateMasterPointChecklistPreventive(
      @Path() int id,
      @Body() MasterPointChecklistPreventive masterPointChecklistPreventive,
      @Header('Authorization') String token);

  @DELETE('$urlLocal/{id}')
  Future<HttpResponse> deleteMasterPointChecklistPreventive(
      @Path() int id, @Header('Authorization') String token);
}
