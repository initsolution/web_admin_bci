import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/tenant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'tenant_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class TenantRepo {
  factory TenantRepo(Dio dio, {String baseUrl}) = _TenantRepo;

  @GET('/tenant')
  Future<HttpResponse<dynamic>> getAllTenant(
      @Header('Authorization') String token,
      @Queries() Map<String, dynamic>? header);

  @POST('/tenant')
  Future<HttpResponse> createTenant(
      @Body() Tenant tenant, @Header('Authorization') String token);

  @PATCH('/tenant/{id}')
  Future<HttpResponse> updateTenant(@Path() int id, @Body() Tenant tenant);
}
