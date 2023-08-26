import 'package:flutter_web_ptb/constants/url.dart';
import 'package:flutter_web_ptb/model/site.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'site_repo.g.dart';

@RestApi(baseUrl: urlRepo)
abstract class SiteRepo {
  factory SiteRepo(Dio dio, {String baseUrl}) = _SiteRepo;

  @GET('/site')
  Future<HttpResponse<dynamic>> getAllSite(
      @Header('Authorization') String token, Map<String, dynamic>? header);

  @POST('/site')
  Future<HttpResponse> createSite(
      @Body() Site site, @Header('Authorization') String token);

  @PATCH('/site/{id}')
  Future<HttpResponse> updateSite(@Path() int id, @Body() Site site);
}
